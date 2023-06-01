import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:when_to_go/repository/navigation/find_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:when_to_go/repository/train/get_subway_time_schedule.dart';
import 'package:when_to_go/repository/notification.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class DetailSchedule extends StatefulWidget {
  DetailSchedule({
    required this.dep_x,
    required this.dep_y,
    required this.stationName,
    required this.laneName,
    required this.upDown,
    required this.stationID,
    Key? key
  }) : super(key: key);

  final double dep_x;
  final double dep_y;
  final stationName;
  final laneName;
  final upDown;
  final stationID;

  @override
  State<DetailSchedule> createState() => _DetailScheduleState();
}

class _DetailScheduleState extends State<DetailSchedule> {


  List<String> a = [];
  List<LatLng> pathList = [];
  var number;
  var wantSchedule;
  var findpath;
  var now_x;
  var now_y;
  bool isBookmark = false;
  Completer<NaverMapController> _controller = Completer();
  var notification = FlutterNotification();
  int offsetMinute = 0;
  int notificationMinute = 0;
  bool alarmTest = false;


  snackbarShow(String a){
    AnimatedSnackBar(
      mobileSnackBarPosition: MobileSnackBarPosition.top,
      duration: const Duration(seconds: 5),
      builder: (context) {
        return Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: Colors.grey, width: 5),
          ),
          padding: const EdgeInsets.all(20),
          child: Center(child: Text(a, style: const TextStyle(color: Colors.black),),),
        );
      },
    ).show(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification.init();
    isBookmark =
        isBookmarked(widget.stationName, widget.laneName, 2, widget.stationID,);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                String text = isBookmark?"추가 되었습니다!":"삭제 되었습니다!";
                await getBookmark(
                    widget.stationName, widget.laneName, 2, widget.stationID,
                    widget.dep_x, widget.dep_y);
                isBookmark = await isBookmarked(
                  widget.stationName, widget.laneName, 2, widget.stationID,);
                setState(() {});
              },
              icon: (isBookmark) ? const Icon(Icons.star) : const Icon(
                  Icons.star_border_outlined),
            ),

          ],
        ),
        body:
        FutureBuilder(
          future: nowScheduleList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ));
            } else if (snapshot.data![0] == -1) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("해당 역까지 가는데 1시간 넘게 걸려요!"),
                    const Text("설마 걸어서 거기까지 가실려구요??"),
                    const Text("저는 비추천 합니다😂"),
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text("처음으로 돌아가기"),
                    ),
                  ],
                ),
              );
            }
            else if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else {
              notificationMinute = snapshot.data![2];
              offsetMinute = snapshot.data![3];
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                            height: 150,
                            child: Center(child: Text(
                              (snapshot.data![2] != 0) ? "${snapshot
                                  .data![2]}분 뒤에 출발하세요!"
                                  : "지금 출발하세요!",
                              style: const TextStyle(fontSize: 40),))
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Flexible(
                              fit: FlexFit.tight,
                              child: Card(
                                color: Colors.white.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      const Text("세부정보", style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),),
                                      Text("해당 역까지 시간: ${snapshot.data![3]}분"),
                                      Text("현재시각: ${DateTime
                                          .now()
                                          .hour}시 ${DateTime
                                          .now()
                                          .minute}분"),
                                      Text("탑승시간: ${snapshot
                                          .data![0]}시 ${snapshot.data![1]}분"),
                                    ],
                                  ),
                                ),
                              )
                          ),
                          const Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 50,),

                    TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text("처음으로 돌아가기",)),

                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          enableDrag: false,
                          isScrollControlled: false,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            double x = (pathList[0].latitude+pathList.last.latitude)/2;
                            double y = (pathList[0].longitude+pathList.last.longitude)/2;

                            return Container(
                              clipBehavior: Clip.hardEdge,
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              height: 400,
                              child: NaverMap(
                                contentPadding: const EdgeInsets.all(10),
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(x,y),
                                  zoom: 13,
                                ),
                                onMapCreated: onMapCreated,
                                mapType: MapType.Basic,
                                locationButtonEnable: true,
                                pathOverlays: {
                                  PathOverlay(
                                    PathOverlayId("test"),
                                    pathList,
                                    width: 10,
                                    color: Colors.blueAccent,
                                    outlineColor: Colors.white,
                                    // patternImage: OverlayImage.fromAssetImage(assetName: assetName)
                                  )
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Text("${widget.stationName}역까지의 경로 보기"),
                    ),
                    TextButton(
                        onPressed: (){
                          alarmTest = true;
                          notification.showNotificationLater(widget.stationName,
                            offsetMinute, notificationMinute);
                          setState(() {

                          });
                        },
                        child: alarmTest?const Text("성공~"):const Text("도착시간 알람 받기")
                    ),
                  ],
                ),
              );
            }
          },
        )
    );
  }

  getPermission() async {
    await Permission.location.request();
    var status = await Permission.location.status;

    if (status.isGranted) {
      print("성공~");
      var location = await Geolocator.getCurrentPosition();
      now_x = location.longitude;
      now_y = location.latitude;

      print(now_x);
      print(now_y);
    } else {
      Permission.location.request();
    }
  }

  Future<List<dynamic>> findSchedule(int upDown) async {
    var a = TimeSchedule(stationId: widget.stationID, wayCode: upDown);
    var json = await a.findTimeSchedule();
    String week = calcWeek();
    print(json);
    List detailSchedule = json["result"][week][(upDown == 1)
        ? "up"
        : "down"]["time"];
    return detailSchedule;
  }

  String calcWeek() {
    switch (DateTime
        .now()
        .weekday) {
      case 6:
        {
          return "SatList";
        }
      case 7:
        {
          return "SunList";
        }
      default:
        {
          return "OrdList";
        }
    }
  }


  findPathTest() async {
    await getPermission();
    findpath = FindPath(
        now_x: now_x, now_y: now_y, dep_x: widget.dep_x, dep_y: widget.dep_y);
    var min = await findpath.findPath();
    pathList = findpath.pathList;
    return min;
  }

  Future<List<int>> nowScheduleList() async {
    var hour = DateTime
        .now()
        .hour;
    var minute = DateTime
        .now()
        .minute;
    int offsetMinute;

    offsetMinute = await findPathTest();

    if (offsetMinute > 60) {
      return [-1];
    }


    if (minute + offsetMinute >= 60) {
      minute += offsetMinute - 60;
      hour++;
    } else {
      minute += offsetMinute;
    }
    Map<int, List<String>> arrr = {};
    var jsonSub = await findSchedule(widget.upDown);
    for (var json in jsonSub) {
      int Idx = json["Idx"];
      List<String> list = json["list"].toString().split(" ");
      List<String> subList = [];
      for (int i = 0; i < list.length; i++) {
        subList.add(list[i].substring(0, 2));
      }
      arrr[Idx] = subList;
    }

    //selectedSchedule의 index는 차례대로
    //[1]: 탑승할 열차 hour
    //[1]: 탑승할 열차 minute
    //[2]: 몇분 후 출발 해야 하는지 minute
    //[3]: 해당 목적지 까지 가는데 걸리는 시간(offsetMinute)
    List<int> selectedSchedule = [];


    if (int.parse(arrr[hour]![arrr[hour]!.length - 1]) < minute) {
      if (arrr[hour + 1] != null) {
        selectedSchedule = [hour + 1, int.parse(arrr[hour + 1]![0])];
      } else {
        selectedSchedule = [0, 0];
      }
    } else {
      List<String> test = arrr[hour]!;
      for (int i = 0; i < test.length; i++) {
        if (int.parse(test[i]) > minute) {
          selectedSchedule = [hour, int.parse(test[i])];
          break;
        }
      }
    }
    print(selectedSchedule);

    List<String> arr = [];

    List first = jsonSub[0]["list"].split(" ");
    first.forEach((element) {
      if (int.parse(element.toString().substring(0, 2)) > minute) {
        arr.add("$hour:${element.toString().substring(0, 2)}");
      }
    });

    print(hour);

    var a = selectedSchedule[1] - DateTime
        .now()
        .minute - offsetMinute - 1;
    if (a < 0) a += 60;
    selectedSchedule.add(a);
    selectedSchedule.add(offsetMinute);
    print(selectedSchedule);

    return selectedSchedule;
  }


  getBookmark(String stationName, String laneName, int stationClass,
      String stationID, double dep_x, double dep_y) {
    String correctLaneName = getCorrectLaneName(laneName);
    var box = Hive.box('bookmark');
    List<dynamic>? a = box.get("list");
    if (a == null) {
      List<dynamic> book = [{
        "stationName": stationName,
        "laneName": correctLaneName,
        "stationClass": stationClass,
        "stationID": stationID,
        "dep_x": dep_x,
        "dep_y": dep_y
      }
      ];
      box.put("list", book);
    } else {
      for (var i in a) {
        if (i["stationName"] == stationName && i["laneName"] == correctLaneName
            && i["stationClass"] == stationClass &&
            i["stationID"] == stationID) {
          a.remove(i);
          box.put("list", a);
          return;
        }
      }
      a.add({
        "stationName": stationName,
        "laneName": correctLaneName,
        "stationClass": stationClass,
        "stationID": stationID,
        "dep_x": dep_x,
        "dep_y": dep_y
      });
      box.put("list", a);
    }
  }

  bool isBookmarked(String stationName, String laneName, int stationClass,
      String stationID) {
    String correctLaneName = getCorrectLaneName(laneName);
    var box = Hive.box('bookmark');
    List<dynamic>? a = box.get("list");
    if (a == null) {
      return false;
    } else {
      for (int i = 0; i < a.length; i++) {
        if (a[i]["stationName"] == stationName && a[i]["laneName"] == correctLaneName
            && a[i]["stationClass"] == stationClass &&
            a[i]["stationID"] == stationID) {
          return true;
        }
      }
      return false;
    }
  }

  void onMapCreated(NaverMapController controller){
    if(_controller.isCompleted) {
      _controller = Completer();
    }
    _controller.complete(controller);
  }

  String getCorrectLaneName(String laneName){
    switch (laneName) {
      case "1호선":
        return "수도권 1호선";
      case "2호선":
        return "수도권 2호선";
      case "3호선":
        return "수도권 3호선";
      case "4호선":
        return "수도권 4호선";
      case "5호선":
        return "수도권 5호선";
      case "6호선":
        return "수도권 6호선";
      case "7호선":
        return "수도권 7호선";
      case "8호선":
        return "수도권 8호선";
      case "9호선":
        return "수도권 9호선";
      case "경강선":
        return "수도권 경강선";
      case "지하철경의중앙선":
        return "경의중앙선";
      case "지하철경춘선":
        return "수도권 경춘선";
      case "공항철도":
        return "수도권 공항철도";
      case "서해선":
        return "수도권 서해선(소사-원시)";
      case "신분당선":
        return "수도권 신분당선";
      case "용인경전철":
        return "수도권 에버라인";
      case "우이신설선":
        return "우이신설경전철";
      case "의정부경전철":
        return "수도권 의정부경전철";
      case "인천지하철2호선":
        return "인천 2호선";
      case "인천지하철1호선":
        return "인천 1호선";
      default :
        return laneName;
    }

  }



}












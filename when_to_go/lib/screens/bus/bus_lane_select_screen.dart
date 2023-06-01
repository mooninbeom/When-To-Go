import 'package:flutter/material.dart';
import 'package:when_to_go/repository/bus/local/get_bus_schedule.dart';
import 'package:when_to_go/screens/bus/bus_result_screen.dart';
import 'package:when_to_go/screens/bus_see_whole_schedule_screen.dart';



class BusLaneSelectScreen extends StatelessWidget {
  BusLaneSelectScreen({
    Key? key,
    // required this.busID,
    required this.localStationID,
    required this.dep_x,
    required this.dep_y,
    required this.busLaneList,
    required this.stationName,
    required this.isScheduleSearchSelected,
    required this.CID,
  }) : super(key: key);


  // final int busID;
  final double dep_x;
  final double dep_y;
  final String localStationID;
  final String stationName;
  final List<String> busLaneList;
  final bool isScheduleSearchSelected;
  final int CID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$stationName"),
      ),
      body: FutureBuilder(
          future: getTimeSchedule(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return ListView.builder(
                itemCount: busLaneList.length,
                itemBuilder: (context, index) {
                  List<Map<String,int>> arriveList=[];
                  print("${busLaneList[index]} =  ${snapshot.data?[busLaneList[index]]}");
                  if(snapshot.data?[busLaneList[index]] != null && snapshot.data?[busLaneList[index]]!.length == 2){
                    // print("${busLaneList[index]} =  ${snapshot.data?[busLaneList[index]]}");
                    if(snapshot.data![busLaneList[index]]![1]["arrtime"]! < snapshot.data![busLaneList[index]]![0]["arrtime"]!){
                      arriveList.add(snapshot.data![busLaneList[index]]![1]);
                      arriveList.add(snapshot.data![busLaneList[index]]![0]);
                    }else{
                      arriveList.add(snapshot.data![busLaneList[index]]![0]);
                      arriveList.add(snapshot.data![busLaneList[index]]![1]);
                    }
                  }else if(snapshot.data?[busLaneList[index]] != null && snapshot.data?[busLaneList[index]]!.length == 1){
                    // print("${busLaneList[index]} =  ${snapshot.data?[busLaneList[index]]}");

                    arriveList.add(snapshot.data![busLaneList[index]]![0]);
                  }
                  // print(arriveList);
                  List<Text>? seeText = [];
                  if(arriveList.isNotEmpty){
                    for(var a in arriveList){
                      double min = a["arrtime"]!.toDouble();
                      int result = (min/60).ceil();
                      seeText.add(Text("$result분 ${a["arrprevstationcnt"]}정거장"));
                    }
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.8),
                    elevation: 1,
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(busLaneList[index], style: TextStyle(fontSize: 18),),
                      subtitle: (seeText.isEmpty)?Text("없습니다"):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: seeText,
                          ),
                      onTap: () async{
                        var busArrivalList = await BusTimeSchedule(nodeID: localStationID, cityCode: 22).getBusTimeSchedule();
                        List<double> selectedBusArrivalList = [];
                        List<int> selectedBusArrivalPrevStList = [];
                        for(var a in busArrivalList){
                          if(a["routeno"].toString() == busLaneList[index]){
                            selectedBusArrivalList.add(a["arrtime"].toDouble());
                            selectedBusArrivalPrevStList.add(a["arrprevstationcnt"]);
                          }
                        }
                        selectedBusArrivalList.sort();
                        selectedBusArrivalPrevStList.sort();
                        // print(selectedBusArrivalList);
                        // print(selectedBusArrivalPrevStList);


                        if(!isScheduleSearchSelected) {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              BusTestScreen(
                                selectedBusArrivalList: selectedBusArrivalList,
                                selectedBusArrivalPrevStList: selectedBusArrivalPrevStList,
                                dep_x: dep_x,
                                dep_y: dep_y,
                              ),));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              BusSeeWholeScheduleScreen(
                                stationName: stationName,
                                selectedBusArrivalList: selectedBusArrivalList,
                                selectedBusArrivalPrevStList: selectedBusArrivalPrevStList,
                              ),));
                        }


                      },
                    ),
                  );
                },);
            }
          }
      ),
    );
  }

  Future<Map<String, List<Map<String,int>>>?> getTimeSchedule() async{
    int cityCode = 22;
    // cityCode = CID==4000 ? 22 : 37100;
    List<dynamic> busArrivalList = await BusTimeSchedule(nodeID: localStationID, cityCode: cityCode).getBusTimeSchedule();
    // print(busArrivalList);

    Map<String, List<Map<String,int>>> arrList = {};
    List<String> test = [];

    for(var a in busArrivalList) {
      // print(a);
      // print(test);
      if(!test.contains(a["routeno"].toString())){
        test.add(a["routeno"].toString());
        arrList[a["routeno"].toString()] =[{"arrtime":a["arrtime"], "arrprevstationcnt":a["arrprevstationcnt"]}];
      }else {
      arrList[a["routeno"].toString()]!.add({
        "arrtime": a["arrtime"],
        "arrprevstationcnt": a["arrprevstationcnt"]
          });
        }

    }

    return arrList;
  }

  /*
  var a = FutureBuilder(
      future: getTimeSchedule(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }else{
          return ListView.builder(
            itemCount: busLaneList.length,
            itemBuilder: (context, index) {

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white.withOpacity(0.8),
                elevation: 1,
                child: ListTile(
                  title: Text(busLaneList[index]),
                  subtitle: (snapshot.data[busLaneList[index]]=e2=null)?Text("없습니다"):
                      Text("있습니다."),
                  onTap: () async{
                    var busArrivalList = await BusTimeSchedule(nodeID: localStationID, cityCode: 22).getBusTimeSchedule();
                    List<double> selectedBusArrivalList = [];
                    List<int> selectedBusArrivalPrevStList = [];
                    for(var a in busArrivalList){
                      if(a["routeno"].toString() == busLaneList[index]){
                        selectedBusArrivalList.add(a["arrtime"].toDouble());
                        selectedBusArrivalPrevStList.add(a["arrprevstationcnt"]);
                      }
                    }
                    selectedBusArrivalList.sort();
                    selectedBusArrivalPrevStList.sort();
                    print(selectedBusArrivalList);
                    print(selectedBusArrivalPrevStList);


                    if(!isScheduleSearchSelected) {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          BusTestScreen(
                            selectedBusArrivalList: selectedBusArrivalList,
                            selectedBusArrivalPrevStList: selectedBusArrivalPrevStList,
                            dep_x: dep_x,
                            dep_y: dep_y,
                          ),));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          BusSeeWholeScheduleScreen(
                            stationName: stationName,
                            selectedBusArrivalList: selectedBusArrivalList,
                            selectedBusArrivalPrevStList: selectedBusArrivalPrevStList,
                          ),));
                    }


                  },
                ),
              );
            },);
        }
      }
  );

   */
}

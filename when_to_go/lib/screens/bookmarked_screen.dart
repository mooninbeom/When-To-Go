import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:when_to_go/screens/see_station_map_screen.dart';
import 'package:when_to_go/screens/subway/subway_select_up_down_screen.dart';



class BookmarkedScreen extends StatefulWidget {
  const BookmarkedScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkedScreen> createState() => _BookmarkedScreenState();
}

class _BookmarkedScreenState extends State<BookmarkedScreen> {

  List<dynamic>? bookmarkedList = [];
  int bookmarkedListCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("즐겨찾기~~"),
      ),
      body: (bookmarkedListCount==0)? const Center(child: Text("없서용~"),):
        ListView.builder(
          itemCount: bookmarkedListCount,
          itemBuilder: (context, index){
            return Card(
              margin: const EdgeInsets.all(10),
              color: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                trailing: IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: (){
                                        deleteBookmark(
                                            bookmarkedList![index]["stationName"],
                                            bookmarkedList![index]["laneName"],
                                            2,
                                            bookmarkedList![index]["stationID"],
                                            bookmarkedList![index]["dep_x"],
                                            bookmarkedList![index]["dep_y"],
                                        );
                                        setState(() {
                                          bookmarkedListCount--;
                                        });
                                      },
                                      child: const Text("삭제")
                                  ),
                                  TextButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                            SeeStationMapScreen(
                                                lat: bookmarkedList![index]["dep_y"],
                                                lon: bookmarkedList![index]["dep_x"],
                                            )
                                          ,));

                                      },
                                      child: const Text("위치보기"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                    );
                  },
                  icon: const Icon(Icons.more_horiz_outlined),
                ),
                title: Text("${bookmarkedList![index]["stationName"]}역"),
                subtitle: Text(bookmarkedList![index]["laneName"]),
                onTap: (){

                  String stationName = bookmarkedList![index]["stationName"];
                  String stationId = bookmarkedList![index]["stationID"];
                  String laneName = bookmarkedList![index]["laneName"];
                  double dep_x = bookmarkedList![index]["dep_x"];
                  double dep_y = bookmarkedList![index]["dep_y"];


                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      SelectUpDown(
                          stationName: stationName,
                          stationId: stationId,
                          laneName: laneName,
                          dep_x: dep_x,
                          dep_y: dep_y
                      )
                    ,));
                },
              ),
            );
          }
      ),
    );
  }


  void getBookmarked(){
    final box = Hive.box("bookmark");
    bookmarkedList = box.get("list");
    bookmarkedListCount = (bookmarkedList==null)?0:bookmarkedList!.length;
  }

  deleteBookmark(String stationName, String laneName, int stationClass,
      String stationID, double dep_x, double dep_y) {
    var box = Hive.box('bookmark');
    List<dynamic>? a = box.get("list");
      for (var i in a!) {
        if (i["stationName"] == stationName && i["laneName"] == laneName
            && i["stationClass"] == stationClass &&
            i["stationID"] == stationID) {
          a.remove(i);
          box.put("list", a);
          return;
        }
      }
  }

}

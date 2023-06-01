import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:when_to_go/repository/public_transit_stop.dart';
import 'package:when_to_go/screens/see_whole_schedule.dart';
import 'package:when_to_go/screens/subway/subway_select_up_down_screen.dart';



class FindSubwayScreen extends StatefulWidget {
  const FindSubwayScreen({
    required this.CID,
    // required this.trainList,
    // required this.totalCount,
    required this.inputText,
    required this.isScheduleSearchSelected,
    Key? key
  }) : super(key: key);

  // final trainList;
  // final totalCount;
  final String inputText;
  final bool isScheduleSearchSelected;
  final int CID;
  @override
  State<FindSubwayScreen> createState() => _FindSubwayScreenState();
}

class _FindSubwayScreenState extends State<FindSubwayScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.totalCount);
    //print(widget.trainList);
  }


  /*
  var a = FutureBuilder(
    future: getStationListJson(widget.inputText),
    builder: (context, snapshot){
      if(!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator(),);
      } else if(snapshot.hasError){
        return Center(child: Text("?????"),);
      } else {
        var trainList = snapshot.data["station"];
        var totalCount = snapshot.data["totalCount"];
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: totalCount,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 1,
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: SvgPicture.asset("assets/${trainList[index]["laneName"]}.svg", width: 50,height: 50,),
                title: Text(trainList[index]["stationName"]),
                subtitle: Text(trainList[index]["laneName"]),
                trailing: const Icon(Icons.play_arrow_rounded),
                onTap: () async{
                  String stationName = trainList[index]["stationName"];
                  String laneName = trainList[index]["laneName"];
                  String stationId = trainList[index]["stationID"].toString();
                  double dep_x = trainList[index]["x"];
                  double dep_y = trainList[index]["y"];


                  if(!mounted) return;

                  if(!widget.isScheduleSearchSelected) {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>
                        SelectUpDown(
                          stationId: stationId,
                          stationName: stationName,
                          laneName: laneName,
                          dep_x: dep_x,
                          dep_y: dep_y,
                        )));
                  } else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        WholeScheduleScreen(stationID: trainList[index]["stationID"],),));
                  }

                },

              ),
            );
          },
        );
      }
    },
  )


   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.inputText}"),
      ),

      body:  FutureBuilder(
        future: getStationListJson(),
        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          } else {
            var trainList = snapshot.data["station"];
            var totalCount = snapshot.data["totalCount"];
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: totalCount,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 1,
                  color: Colors.white.withOpacity(0.8),
                  child: ListTile(
                    leading: SvgPicture.asset("assets/${trainList[index]["laneName"]}.svg", width: 50,height: 50,),
                    title: Text(trainList[index]["stationName"]),
                    subtitle: Text(trainList[index]["laneName"]),
                    trailing: const Icon(Icons.play_arrow_rounded),
                    onTap: () async{
                      String stationName = trainList[index]["stationName"];
                      String laneName = trainList[index]["laneName"];
                      String stationId = trainList[index]["stationID"].toString();
                      double dep_x = trainList[index]["x"];
                      double dep_y = trainList[index]["y"];


                      if(!mounted) return;

                      if(!widget.isScheduleSearchSelected) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            SelectUpDown(
                              stationId: stationId,
                              stationName: stationName,
                              laneName: laneName,
                              dep_x: dep_x,
                              dep_y: dep_y,
                            )));
                      } else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            WholeScheduleScreen(stationID: trainList[index]["stationID"],),));
                      }

                    },

                  ),
                );
              },
            );
          }
        },
      )

    );
  }

  Future<dynamic> getStationListJson() async{
    String inputText = widget.inputText;
    if(inputText.toString().endsWith("역")) inputText = inputText.toString().substring(0,inputText.toString().length-1);


    var a = PublicTransitStop(CID: widget.CID, stationClass: 2, stationName: inputText, );
    print(a);
    var json = await a.findPublicTransitStop();
    print(json);
    return json;
  }
}

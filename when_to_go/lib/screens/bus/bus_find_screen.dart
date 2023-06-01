import 'package:flutter/material.dart';
import 'package:when_to_go/repository/public_transit_stop.dart';
import 'package:when_to_go/screens/bus/bus_lane_select_screen.dart';



class FindBusScreen extends StatefulWidget {
  const FindBusScreen({
    Key? key,
    required this.CID,
    required this.isScheduleSearchSelected,
    // required this.stationList,
    // required this.totalCount,
    required this.inputText,
  }) : super(key: key);

  final bool isScheduleSearchSelected;
  // final stationList;
  // final totalCount;
  final inputText;
  final int CID;

  @override
  State<FindBusScreen> createState() => _FindBusScreenState();
}

class _FindBusScreenState extends State<FindBusScreen> {
  Future<dynamic> getStationListJson() async{
    String inputText = widget.inputText;

    var a = PublicTransitStop(CID: widget.CID, stationClass: 1, stationName: inputText, );
    print(a);
    var json = await a.findPublicTransitStop();
    print(json);
    return json;
  }

  /*
  var test = FutureBuilder(
      future: getStationListJson(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        } else{
          var stationList = snapshot.data["station"];
          var totalCount = snapshot.data["totalCount"];
          return ListView.builder(
            itemCount: totalCount,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                elevation: 1,
                color: Colors.white.withOpacity(0.8),
                child: ListTile(
                  title: Text(stationList[index]["stationName"]),
                  onTap: (){
                    List<String> busLaneList = [];
                    print(stationList[index]["businfo"]);
                    for(var a in stationList[index]["businfo"]){
                      if (!busLaneList.contains(a["busNo"].substring(0,3))){
                        busLaneList.add(a["busNo"].substring(0,3));
                      }
                    }
                    busLaneList.sort();
                    print(busLaneList);
                    print(stationList[index]["localStationID"]);


                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        BusLaneSelectScreen(
                          stationName: stationList[index]["stationName"],
                          busID: stationList[index]["stationID"],
                          localStationID: stationList[index]["localStationID"],
                          dep_x: stationList[index]["x"],
                          dep_y: stationList[index]["y"],
                          busLaneList: busLaneList,
                          isScheduleSearchSelected: widget.isScheduleSearchSelected,
                        ),));
                  },
                ),
              );
            },);
        }
      },

  );

   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.inputText}"),
      ),
      body: FutureBuilder(
        future: getStationListJson(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          } else{
            var stationList = snapshot.data["station"];
            var totalCount = snapshot.data["totalCount"];
            return ListView.builder(
              itemCount: totalCount,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 1,
                  color: Colors.white.withOpacity(0.8),
                  child: ListTile(
                    title: Text(stationList[index]["stationName"]),
                    onTap: (){
                      List<String> busLaneList = [];
                      // print(stationList[index]["businfo"]);
                      for(var a in stationList[index]["businfo"]){
                        if (!busLaneList.contains(a["busNo"].substring(0,3))){
                          busLaneList.add(a["busNo"].substring(0,3));
                        }
                      }
                      busLaneList.sort();
                      // print(busLaneList);
                      print(stationList[index]["localStationID"]);


                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          BusLaneSelectScreen(
                            stationName: stationList[index]["stationName"],
                            // busID: stationList[index]["stationID"],
                            localStationID: stationList[index]["localStationID"],
                            dep_x: stationList[index]["x"],
                            dep_y: stationList[index]["y"],
                            busLaneList: busLaneList,
                            isScheduleSearchSelected: widget.isScheduleSearchSelected,
                            CID: widget.CID,
                          ),));
                    },
                  ),
                );
              },);
          }
        },

      ),
    );
  }
}

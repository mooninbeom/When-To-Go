import 'package:flutter/material.dart';
import 'package:when_to_go/repository/train/get_subway_time_schedule.dart';
import 'package:when_to_go/screens/subway/subway_result_screen.dart';
import 'package:when_to_go/repository/train/up_down_name.dart';


class SelectUpDown extends StatelessWidget {
  const SelectUpDown({
    required this.stationName,
    required this.stationId,
    required this.laneName,
    required this.dep_x,
    required this.dep_y,
    Key? key
  }) : super(key: key);


  final String stationName;
  final String stationId;
  final String laneName;
  final double dep_x;
  final double dep_y;


  /*
  Future<List<dynamic>> findSchedule(int upDown) async{
    var a = TimeSchedule(stationId: stationId, wayCode: upDown);
    var json = await a.findTimeSchedule();
    String week = calcWeek();
    List detailSchedule = json["result"][week][(upDown==1)?"up":"down"]["time"];
    return detailSchedule;
  }

  String calcWeek(){
    switch (DateTime.now().weekday){
      case 6:{
        return "SatList";
      }
      case 7: {
        return "SunList";
      }
      default: {
        return "OrdList";
      }
    }
  }

   */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$stationName"),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {
                    // var upDownJson = await findSchedule(1);
                    // print(upDownJson);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailSchedule(
                        stationName: stationName,
                        laneName: laneName,
                        upDown: 1,
                        // scheduleJson: upDownJson,
                        dep_x: dep_x,
                        dep_y: dep_y,
                        stationID: stationId,
                    ),));

                  }, icon: const Icon(Icons.arrow_upward_outlined), iconSize: 40),
                  const Text("상행"),
                  Text("${UpDownName(laneName: laneName).findName()[0]} 방면"),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){
                    // var upDownJson = await findSchedule(2);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailSchedule(
                        stationName: stationName,
                        laneName: laneName,
                        upDown: 2,
                        dep_x: dep_x,
                        dep_y: dep_y,
                        stationID: stationId,
                    ),));

                  }, icon: const Icon(Icons.arrow_downward_outlined), iconSize: 40, ),
                  const Text("하행"),
                  Text("${UpDownName(laneName: laneName).findName()[1]} 방면"),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

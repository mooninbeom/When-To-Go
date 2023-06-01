import 'package:flutter/material.dart';
import 'package:when_to_go/repository/train/get_subway_time_schedule.dart';



class WholeScheduleScreen extends StatefulWidget {
  const WholeScheduleScreen({
    required this.stationID,
    // required this.upSchedule,
    // required this.downSchedule,
    Key? key
  }) : super(key: key);
  // final Future<dynamic> downSchedule;
  final stationID;

  @override
  State<WholeScheduleScreen> createState() => _WholeScheduleScreenState();
}

class _WholeScheduleScreenState extends State<WholeScheduleScreen> {
  int wayCode = 1;
  int weekday = 0;
  List<bool> isSelectedList = [true, false];
  List<bool> weekdayList = [true, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          ToggleButtons(
              borderColor: Colors.black.withOpacity(0.5),
              selectedBorderColor: Colors.deepPurple.withOpacity(0.4),
              fillColor: Colors.deepPurple.withOpacity(0.4),
              selectedColor: Colors.white,
              splashColor: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),

              isSelected: weekdayList,
              onPressed: (index){
                switch (index){
                  case 0: {
                    weekdayList[0] = true;
                    weekdayList[1] = false;
                    weekdayList[2] = false;
                    setState(() {
                      weekday = 0;
                    });
                    break;
                  }
                  case 1: {
                    weekdayList[0] = false;
                    weekdayList[1] = true;
                    weekdayList[2] = false;
                    setState(() {
                      weekday = 1;
                    });
                    break;
                  }
                  case 2: {
                    weekdayList[0] = false;
                    weekdayList[1] = false;
                    weekdayList[2] = true;
                    setState(() {
                      weekday = 2;
                    });
                    break;
                  }
                }
              },
              children: const <Widget>[
                Text("평일"),
                Text("토"),
                Text("일"),
              ],
          ),
          const SizedBox(width: 10,),
          ToggleButtons(
              borderColor: Colors.black.withOpacity(0.5),
              selectedBorderColor: Colors.deepPurple.withOpacity(0.4),
              fillColor: Colors.deepPurple.withOpacity(0.4),
              selectedColor: Colors.white,
              splashColor: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              isSelected: isSelectedList,
              onPressed: (index){
                if(index==1){
                  isSelectedList[1] = true;
                  isSelectedList[0] = false;
                  setState(() {
                    wayCode = 2;
                  });
                }else{
                  isSelectedList[1] = false;
                  isSelectedList[0] = true;
                  setState(() {
                    wayCode = 1;
                  });
                }
              },
              children: const <Widget>[
                Text("상행"),
                Text("하행"),
              ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: getSchedule(wayCode, weekday),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }else{
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    margin: const EdgeInsets.all(10),
                    color: Colors.white.withOpacity(0.8),

                    child: ListTile(
                      title: Text("${snapshot.data![index]["Idx"]}시"),
                      subtitle: Text("${snapshot.data![index]["list"]}"),
                    ),
                  );
                },
            );
          }
        },
      ),
    );
  }
  Future<List<dynamic>> getSchedule(int wayCode, int weekday) async{
    var a = TimeSchedule(stationId: widget.stationID, wayCode: wayCode);
    var json = await a.findTimeSchedule();
    String week = "OrdList";
    switch (weekday){
      case 0 : {
        week = "OrdList";
        break;
      }
      case 1 : {
        week = "SatList";
        break;
      }
      case 2 : {
        week = "SunList";
        break;
      }
    }
    // print(json);
    List<dynamic> result = json["result"][week][(wayCode==1)?"up":"down"]["time"];
    return result;
  }
}

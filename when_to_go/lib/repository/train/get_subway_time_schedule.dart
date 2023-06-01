import 'dart:convert';
import 'package:http/http.dart';
import 'package:when_to_go/env/key.dart';






class TimeSchedule{

  final stationId;
  final lang = 0;
  final wayCode;
  final showExpressTime = 1;
  final sepExpressTime = 0;
  final apiKey = Key().PUBLICTRANSITSTOPKEY;

  TimeSchedule({required this.stationId, required this.wayCode});



  findTimeSchedule() async{
    var responseUrl = "https://api.odsay.com/v1/api/subwayTimeTable?"
        "apiKey=$apiKey&"
        "lang=$lang&"
        "stationID=$stationId&"
        "wayCode=$wayCode&"
        "showExpressTime=$showExpressTime&"
        "sepExpressTime=$sepExpressTime";

    var response = await get(Uri.parse(responseUrl));

    if(response.statusCode == 200){
      var responseJson = jsonDecode(response.body);
      // print(responseJson);
      return responseJson;

    }
  }

}

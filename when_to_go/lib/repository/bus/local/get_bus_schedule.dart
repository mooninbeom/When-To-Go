import 'dart:convert';
import 'package:when_to_go/env/key.dart';
import 'package:http/http.dart' as http;


class BusTimeSchedule{
  final String serviceKey = Key().SEOULBUSKEY;
  final int cityCode;
  final nodeID;

  BusTimeSchedule({
    required this.nodeID,
    required this.cityCode
  });


  getBusTimeSchedule() async{
    String url = "http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList?"
        "serviceKey=$serviceKey&"
        "numOfRows=100&"
        "_type=json&"
        "cityCode=$cityCode&"
        "nodeId=$nodeID";

    http.Response response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      var scheduleJson = jsonDecode(utf8.decode(response.bodyBytes));
      print(scheduleJson);
      return scheduleJson["response"]["body"]["items"]["item"];
    }
  }


}
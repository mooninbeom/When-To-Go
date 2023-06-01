import 'dart:convert';
import 'package:when_to_go/env/key.dart';
import 'package:http/http.dart' as http;





class SeoulBusTransit{
  final String _apiKey = Key().SEOULBUSKEY;



  Future<List<dynamic>> getStationID(String name) async{
    var url = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByName?"
        "serviceKey=$_apiKey&"
        "stSrch=$name&"
        "resultType=json";

    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return json["msgBody"]["itemList"];
    }
    return [];
  }

  Future<List<dynamic>> getBusArrv(String arsId) async{
    var url = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid?"
        "serviceKey=$_apiKey&"
        "arsId=$arsId&"
        "resultType=json";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> result = json["msgBody"]["itemList"];
      return result;
    }
    return [];
  }


}




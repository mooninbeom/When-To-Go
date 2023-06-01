import 'dart:convert';
import 'package:when_to_go/env/key.dart';
import 'package:http/http.dart';





class GetBusLane{
  final String _apiKey = Key().GETBUSSTATIONINFOKEY;
  final int _pageNo = 1;
  final int _numOfRows = 100;
  final String _type = "json";
  final int cityCode = 22;
  final String nodeid;

  GetBusLane({required this.nodeid});

  Future<List<String>> getBusLane() async{
    var url = "http://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnThrghRouteList?"
        "serviceKey=$_apiKey&"
        "pageNo=$_pageNo&"
        "numOfRows=$_numOfRows&"
        "_type=$_type&"
        "cityCode=$cityCode&"
        "nodeid=$nodeid";

    // print(nodeid);
    var response = await get(Uri.parse(url));
    if(response.statusCode == 200){
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      print(nodeid);
      print(json);
      List<String> result = [];
      List<dynamic> stationJson = json["response"]["body"]["items"]["item"];

      for(var a in stationJson){
        if(result.contains(a["routeno"].toString())) continue;
        result.add(a["routeno"].toString());
      }
      result.sort();
      return result;
    }
    return ["nothing"];
  }
}
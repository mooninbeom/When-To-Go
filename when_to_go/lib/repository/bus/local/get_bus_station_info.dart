import 'dart:convert';
import 'package:when_to_go/env/key.dart';
import 'package:http/http.dart' as http;




class GetBusStationInfo{
  final String _appKey = Key().GETBUSSTATIONINFOKEY;
  final int _pageNo = 1;
  final int _numOfRows = 100;
  final String _type = "json";
  final int _cityCode = 22;
  final String nodeNm;


  GetBusStationInfo({required this.nodeNm});


  Future<List<String>> getBusStationId() async{
    var url = "http://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?"
        "serviceKey=$_appKey&"
        "pageNo=$_pageNo&"
        "numOfRows=$_numOfRows&"
        "_type=$_type&"
        "cityCode=$_cityCode&"
        "nodeNm=$nodeNm";

    var response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if(response.statusCode==200){
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      print(json);
      List<String> result = [json["response"]["body"]["items"]["item"]["nodeid"],json["response"]["body"]["items"]["item"]["nodenm"]];
      print(result);
      return result;
    }
    return [];

  }




}
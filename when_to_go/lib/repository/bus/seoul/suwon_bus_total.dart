import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:when_to_go/env/key.dart';






class SuwonBusTotal{
  final String _apiKey = Key().SEOULBUSKEY;


  getBusList(String busName) async{
    var url = "http://apis.data.go.kr/6410000/busstationservice/getBusStationList?"
        "serviceKey=$_apiKey&"
        "keyword=$busName";

    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var xml = response.body;
      var change = Xml2Json()..parse(xml);
      var parcker = change.toParker();
      var json = jsonDecode(parcker);
      print(json);
      return json;
    }
  }
}
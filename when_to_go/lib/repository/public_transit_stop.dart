import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:when_to_go/env/key.dart';

class PublicTransitStop{
  final apiKey = Key().PUBLICTRANSITSTOPKEY;
  final lang = 0;
  final int CID;
  final int stationClass;
  final String stationName;
  late final stationId;

  PublicTransitStop({
    required this.CID,
    required this.stationClass,
    required this.stationName,
  });

  List<dynamic> busInfo = [];
  var totalCount;
  var stationList;
  var requestUrl;



  findPublicTransitStop() async{
    // print("fdafds");
    // var location = await Location().getLocation();
    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.bestForNavigation,
    // );
    // print("fd");
    requestUrl ="https://api.odsay.com/v1/api/searchStation?"
        "apiKey=$apiKey&"
        "lang=$lang&"
        "stationName=$stationName&"
        "CID=$CID&"
        "stationClass=$stationClass";
        // "myLocation=$position.longitude}:${position.latitude}";

    final response = await http.get(Uri.parse(requestUrl));


    if(response.statusCode==200){
      final findPublicTransitStopJson = jsonDecode(response.body);
      // print(findPublicTransitStopJson);
      // totalCount = findPublicTransitStopJson["result"]["totalCount"];
      // stationList = findPublicTransitStopJson["result"]["station"];
      print(stationList);
      return findPublicTransitStopJson["result"];

    }
  }
}


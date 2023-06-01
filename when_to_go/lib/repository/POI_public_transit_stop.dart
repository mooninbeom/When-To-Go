import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:when_to_go/main.dart';
import 'package:when_to_go/repository/bus/local/get_bus_lane.dart';
import 'package:when_to_go/repository/bus/local/get_bus_station_info.dart';
import 'package:when_to_go/screens/bus/bus_lane_select_screen.dart';
import 'package:when_to_go/screens/bus/seoul_bus_find_screen.dart';
import 'package:when_to_go/screens/subway/subway_select_up_down_screen.dart';
import 'package:when_to_go/env/key.dart' as api;





class POIPublicTransitStop{
  final String _appKey = api.Key().FINDPATHKEY;
  final String _categories = "지하철;버스정류장";
  final String _reqCoordType = "WGS84GEO";
  final String _resCoordType = "WGS84GEO";
  final String _multiPoint = "N";
  final String _sort = "distance";
  final int _page = 1;
  final int _count = 200;
  final int _radius = 1;

  final double centerLon;
  final double centerLat;

  POIPublicTransitStop({
    required this.centerLon,
    required this.centerLat,
  });


  Future<List<dynamic>?> getPOIPublicTransitStop() async{
    var url = "https://apis.openapi.sk.com/tmap/pois/search/around?version=1&"
        "page=$_page&"
        "count=$_count&"
        "categories=$_categories&"
        "centerLon=$centerLon&"
        "centerLat=$centerLat&"
        "radius=$_radius&"
        "reqCoordType=$_reqCoordType&"
        "resCoordType=$_resCoordType&"
        "multiPoint=$_multiPoint&"
        "sort=$_sort&"
        "appKey=$_appKey";

    var response = await http.get(Uri.parse(url));

    if(response.statusCode==200){
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      List<dynamic>? searchList = json["searchPoiInfo"]["pois"]["poi"];
      print(json["searchPoiInfo"]["totalCount"]);
      return searchList;
    }else{
      return null;
    }

  }

  Future<int> getStationId(String name, String lane) async{
    if(name.contains("대구")) {
      String sub1 = name.split("[")[0];
      sub1 = sub1.substring(0, sub1.length - 1);
      String jsonString = await rootBundle.loadString(
          'assets/json/deagu_station_code.json');
      var json = jsonDecode(jsonString);
      int code = json[lane][sub1];
      return code;
    }else{
      String jsonString = await rootBundle.loadString(
        'assets/json/station_coordinate.json'
      );
      List<dynamic> json = jsonDecode(jsonString);
      int code = 0;
      for(var a in json){
        if(a["line"]==lane && a["name"]==name){
          code = a["code"];
        }
      }
      return code;
    }

  }


  List<Marker> changeToMarker(List<dynamic>? json) {
    List<Marker> result = [];

    if(json==null){
      return [];
    }else{
      for(var a in json){
        result.add(Marker(
            markerId: a["name"],
            position: LatLng(double.parse(a["noorLat"]), double.parse(a["noorLon"])),
            captionText: a["name"],

            onMarkerTab: (marker, iconSize) async{
              String? name = marker!.captionText;
              String laneName="";
              List<String> busName=[];
              String stationName="";
              String codeS="";
              List<String> busList = [];

              //api에 맞게 parsing
              if(name!.contains("대구지하철1호선")){
                laneName = "대구 1호선";
              }else if(name.contains("대구지하철2호선")){
                laneName = "대구 2호선";
              } else if(name.contains("대구지하철3호선")){
                laneName = "대구 3호선";
              } else{
                laneName = name.split("[")[1].split("]")[0];
              }

              if(name.contains("[버스정류장]")){
                stationName = name.split("[")[0];
                print(a["upperAddrName"]);
                //버스 선택시
                if(!(a["upperAddrName"].toString() == "서울")){
                  var i = GetBusStationInfo(nodeNm: stationName);
                  busName = await i.getBusStationId();
                  busList = await GetBusLane(nodeid: busName[0]).getBusLane();
                }
              } else {
                //지하철 선택시
                String sub1 = a["name"].toString().split("[")[0];
                stationName = sub1.substring(0, sub1.length - 1);
                int code = await getStationId(name, laneName);
                codeS = code.toString();
                print(code);
              }
              navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) {
                if(!name.contains("[버스정류장]")){
                  print("$stationName 이고 $laneName 이고 $codeS 이다");
                  return SelectUpDown(
                    laneName: laneName,
                    stationName: stationName,
                    dep_x: marker.position!.longitude,
                    dep_y: marker.position!.latitude,
                    stationId: codeS,
                  );
                }else if(!(a["upperAddrName"]=="서울")){
                  return BusLaneSelectScreen(
                    // busID: int.parse(busName[1]),
                    localStationID: busName[0],
                    dep_x: marker.position!.longitude,
                    dep_y: marker.position!.latitude,
                    busLaneList: busList,
                    stationName: stationName,
                    isScheduleSearchSelected: true,
                    CID: 4000,
                  );
                  } else{
                    return SeoulBusFindScreen(busName: stationName);
                }
                }
                ,));
            },
        ));
      }
      return result;
    }
  }

}
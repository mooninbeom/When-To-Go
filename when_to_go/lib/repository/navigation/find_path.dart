import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:when_to_go/env/key.dart';


class FindPath {
  final String _appKey = Key().FINDPATHKEY;
  final String _startName = "%EC%B6%9C%EB%B0%9C";
  final String _endName = "%EB%8F%84%EC%B0%A9";

  final double now_x;
  final double now_y;
  final double dep_x;
  final double dep_y;


  FindPath({
    required this.now_x,
    required this.now_y,
    required this.dep_x,
    required this.dep_y,
  });

  List<LatLng> pathList = [];


  findPath() async {
    var url = "https://apis.openapi.sk.com/tmap/routes/pedestrian?"
        "version=1&"
        "appKey=$_appKey&"
        "startX=$now_x&"
        "startY=$now_y&"
        "endX=$dep_x&"
        "endY=$dep_y&"
        "startName=$_startName&"
        "endName=$_endName&"
        "speed=4";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      var totalTime = (json["features"][0]["properties"]["totalTime"] / 60)
          .ceil();
      // print(totalTime);
      List<dynamic>? featureList = json["features"];

      if (featureList != null) {
        for (var a in featureList) {
          if(a["geometry"]["type"]=="LineString"){
            for (var b in a["geometry"]["coordinates"]){
              // print(b[1]);
              // if(pathList.last == LatLng(b[1], b[0])) continue;
              pathList.add(LatLng(b[1], b[0]));
            }
          }


            // pathList.add(LatLng(a["geometry"]["coordinates"][1], a["geometry"]["coordinates"][0]));

        }
      }
      print(pathList);
      return totalTime;
    } else {
      return response.statusCode;
    }
  }

}

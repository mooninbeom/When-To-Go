import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:when_to_go/repository/bus/seoul/seoul_bus_total.dart';
import 'package:when_to_go/screens/bus/seoul_bus_lane_screen.dart';






class SeoulBusFindScreen extends StatefulWidget {
  const SeoulBusFindScreen({Key? key, required this.busName}) : super(key: key);

  final String busName;
  @override
  State<SeoulBusFindScreen> createState() => _SeoulBusFindScreenState();
}

class _SeoulBusFindScreenState extends State<SeoulBusFindScreen> {


  Completer<NaverMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.busName),
      ),
      body: FutureBuilder(
        future: getBusList(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }else if(snapshot.data == null){
            return const Center(child: Text("데이터가 없습니당"),);
          }else{
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]["stNm"]),
                    subtitle: Text(snapshot.data![index]["arsId"]),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SeoulBusLaneScreen(
                        stationName: snapshot.data![index]["stNm"],
                        arsId: snapshot.data![index]["arsId"],
                      ),));

                    },
                    trailing: TextButton(
                      child: const Text("위치보기"),
                      onPressed: (){
                        showModalBottomSheet(
                          enableDrag: false,
                          isScrollControlled: false,
                          backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {

                              double x = double.parse(snapshot.data![index]["tmY"]);
                              double y = double.parse(snapshot.data![index]["tmX"]);
                              return Container(

                                clipBehavior: Clip.hardEdge,
                                margin: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 60),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                height: 400,
                                child: NaverMap(
                                  contentPadding: const EdgeInsets.all(10),
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(x,y),
                                    zoom: 16,
                                  ),
                                  onMapCreated: onMapCreated,
                                  mapType: MapType.Basic,
                                  locationButtonEnable: true,
                                  markers: [
                                    Marker(markerId: "dd", position: LatLng(x,y),
                                    captionText: snapshot.data![index]["stNm"])
                                  ],
                                ),
                              );
                              }
                            ,
                        );
                      },
                    ),
                  );
                },
            );
          }
        },
      ),
    );
  }
  void onMapCreated(NaverMapController controller){
    if(_controller.isCompleted) {
      _controller = Completer();
    }
    _controller.complete(controller);
  }

  Future<List<dynamic>> getBusList() async{
    var json = SeoulBusTransit();
    List<dynamic> busList = await json.getStationID(widget.busName);
    return busList;
  }



}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:when_to_go/repository/POI_public_transit_stop.dart';




class POISearchScreen extends StatefulWidget {
  POISearchScreen({Key? key, required this.lat, required this.lon }) : super(key: key);

  double lat;
  double lon;

  @override
  State<POISearchScreen> createState() => _POISearchScreenState();
}

class _POISearchScreenState extends State<POISearchScreen> {
  static Completer<NaverMapController> _controller = Completer();
  static const MapType _mapType = MapType.Basic;
  double? mapLat;
  double? mapLon;

  late LatLng mapPosition;
  late CameraChangeReason test;
  late bool isAnimated;

  static void onMapCreated(NaverMapController controller){
    if(_controller.isCompleted) {
      _controller = Completer();
    }
    _controller.complete(controller);
  }

  Future<List<Marker>> makePoiMarkerList() async{
    var a = POIPublicTransitStop(centerLon: widget.lon, centerLat: widget.lat);

    var json = await a.getPOIPublicTransitStop();
    List<Marker> result = a.changeToMarker(json);

    return result;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: makePoiMarkerList(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }else{
            return Stack(
              children: [
                NaverMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat, widget.lon),
                ),
                onMapCreated: onMapCreated,
                mapType: _mapType,
                markers: snapshot.data!,
                locationButtonEnable: true,
                onCameraChange: _onCameraChange,
                onCameraIdle: _onCameraIdle,
                ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(11, 12, 11, 12)),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))

                          ),
                          onPressed: (){
                            widget.lat = mapLat!;
                            widget.lon = mapLon!;
                            setState(() {

                            });
                          },
                          child: const Text("현재위치에서 재검색")),
                    ),
                  ],
                ),

              ],
            );
          }
        },

      )

    );
  }

  void _onCameraIdle(){
    print('카메라 멈춤');
  }

  void _onCameraChange(
      LatLng? latLng, CameraChangeReason reason, bool? isAnimated) {
    mapLat = latLng?.latitude;
    mapLon = latLng?.longitude;
    print('카메라 움직임 >>> 위치 : ${latLng?.latitude}, ${latLng?.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
  }



}

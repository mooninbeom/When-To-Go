import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';





class SeeStationMapScreen extends StatefulWidget {
  const SeeStationMapScreen({Key? key, required this.lat, required this.lon}) : super(key: key);

  final double lat;
  final double lon;

  @override
  State<SeeStationMapScreen> createState() => _SeeStationMapScreenState();
}

class _SeeStationMapScreenState extends State<SeeStationMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: NaverMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lon),
          zoom: 15,
        ),
        markers: [
          Marker(markerId: "1", position: LatLng(widget.lat, widget.lon)),
        ],
      ),
    );
  }
}

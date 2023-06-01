import 'package:flutter/material.dart';
import 'package:when_to_go/repository/bus/seoul/seoul_bus_total.dart';





class SeoulBusLaneScreen extends StatefulWidget {
  const SeoulBusLaneScreen({Key? key, required this.stationName, required this.arsId}) : super(key: key);
  final String stationName;
  final String arsId;

  @override
  State<SeoulBusLaneScreen> createState() => _SeoulBusLaneScreenState();
}

class _SeoulBusLaneScreenState extends State<SeoulBusLaneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: FutureBuilder(
        future: SeoulBusTransit().getBusArrv(widget.arsId),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          } else if(snapshot.data == null){
            return Text("no data");
          } else{
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${snapshot.data![index]["rtNm"]}"),
                    subtitle: Text("${snapshot.data![index]["arrmsg1"]}\n${snapshot.data![index]["arrmsg2"]}"),
                  );
                },
            );
          }
        },
      ),
    );
  }


}

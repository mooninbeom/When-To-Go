import 'package:flutter/material.dart';


class BusSeeWholeScheduleScreen extends StatelessWidget {
  const BusSeeWholeScheduleScreen({
    required this.stationName,
    required this.selectedBusArrivalPrevStList,
    required this.selectedBusArrivalList,
    Key? key
  }) : super(key: key);

  final String stationName;
  final List<double> selectedBusArrivalList;
  final List<int> selectedBusArrivalPrevStList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(stationName),
      ),
      body: (selectedBusArrivalList.isEmpty)? const Center(child: Text("해당 도착 정보 없음요 ㅋ")):
          ListView.builder(
              itemCount: selectedBusArrivalList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  color: Colors.white.withOpacity(0.8),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("${(selectedBusArrivalList[index]/60).ceil()}분 남음"),
                    subtitle: Text("${selectedBusArrivalPrevStList[index]} 정거장 남음"),
                  ),
                );
              },
          )

    );
  }
}

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:when_to_go/repository/navigation/find_path.dart';


class BusTestScreen extends StatefulWidget {
  const BusTestScreen({
    Key? key,
    required this.selectedBusArrivalPrevStList,
    required this.selectedBusArrivalList,
    required this.dep_x,
    required this.dep_y,
  }) : super(key: key);

  final List<double> selectedBusArrivalList;
  final List<int> selectedBusArrivalPrevStList;
  final double dep_x;
  final double dep_y;

  @override
  State<BusTestScreen> createState() => _BusTestScreenState();
}

class _BusTestScreenState extends State<BusTestScreen> {

  Future<int> getOffsetTime() async{
    var location = await Location().getLocation();
    double? now_x = location.longitude;
    double? now_y = location.latitude;

    var pathFinder = FindPath(now_x: now_x!, now_y: now_y!, dep_x: widget.dep_x, dep_y: widget.dep_y);
    int offset = await pathFinder.findPath();

    return offset;
  }

  Future<List<int>> getResultTime() async{
    var offsetMinute = await getOffsetTime();
    int i=0;

    for(var a in widget.selectedBusArrivalList){
      i++;
      if(offsetMinute<(a/60).ceil()){
        i--;
        return [offsetMinute, (a/60).ceil(), i];
      }
    }
    return [];
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: (widget.selectedBusArrivalList.isEmpty)? const Center(child: Text("해당 도착 정보 없음요 ㅋ")):
          FutureBuilder(
            future: getResultTime(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if(snapshot.hasError){
                return Center(
                  child: Text("${snapshot.error} 입니다."),
                );
              } else if(snapshot.data!.isEmpty){
                return const Center(
                  child: Text("님 도착 못해요~"),
                );
              }


              else {
                Text number = ((snapshot.data![1]-snapshot.data![0]) <= 0)? const Text("지금 출발하세요!", style: TextStyle(fontSize: 40),):
                  Text("${(snapshot.data![1]-snapshot.data![0])}분 뒤에 출발하세요!", style: const TextStyle(fontSize: 40),);
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Card(
                            color: Colors.white.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Center(child: number),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Flexible(
                                  flex: 4,
                                  fit: FlexFit.tight,
                                  child: Card(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("세부정보", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                          Text("해당 정류장 까지 시간: ${snapshot.data![0]}분"),
                                          Text("도착 시간: ${snapshot.data![1]}분 뒤"),
                                          Text("남은 정류장: ${widget.selectedBusArrivalPrevStList[snapshot.data![2]]}개"),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                              const Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: SizedBox(),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            child: const Text("처음으로 돌아가기")),
                      ],
                    ),
                  ),
                );
              }
            },)
        
        
        
        
        
        
        
      // (widget.selectedBusArrivalList.isEmpty)? const Text("해당 도착 정보 없음요 ㅋ")
      //     :ListView.builder(
      //       itemCount: widget.selectedBusArrivalList.length,
      //       itemBuilder: (context, index) {
      //
      //        return ListTile(
      //          title: Text("${(widget.selectedBusArrivalList[index]/60).ceil()}min left"),
      //          subtitle: Text("${widget.selectedBusArrivalPrevStList[index]}정류장 남음"),
      //     );
      // },),
    );
  }
}

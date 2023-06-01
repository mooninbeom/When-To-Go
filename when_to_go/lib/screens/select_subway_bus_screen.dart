import 'package:flutter/material.dart';
import 'package:when_to_go/screens/input_text_screen.dart';




class SelectBusSubScreen extends StatefulWidget {
  SelectBusSubScreen({Key? key, required this.isScheduleSearchSelected}) : super(key: key);
  final bool isScheduleSearchSelected;

  @override
  State<SelectBusSubScreen> createState() => _SelectBusSubScreenState();
}

class _SelectBusSubScreenState extends State<SelectBusSubScreen> {

  // getPermission() async{
  //   await Permission.location.request();
  // }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPermission();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      // appBar: AppBar(
      //   titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      //   centerTitle: true,
      //   title: const Text("Where to go?",style: TextStyle(color: Colors.black)),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 200,),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> InputTextScreen(stationClass: 2, isScheduleSearchSelected: widget.isScheduleSearchSelected,)));
                      },
                      icon: const Hero(tag: "subway",child: Icon(Icons.subway_outlined,)),
                      iconSize: 70,
                    ),
                    const Text("지하철", style: TextStyle(fontWeight: FontWeight.w600),),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InputTextScreen(stationClass: 1, isScheduleSearchSelected: widget.isScheduleSearchSelected),));
                      },
                      icon: const Hero(tag: "bus",child: Icon(Icons.directions_bus)),
                      iconSize: 70,
                    ),
                    const Text("시내버스", style: TextStyle(fontWeight: FontWeight.w600),)
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 100,),
          const Center(
            child: Text("이용하실 대중교통을 선택해 주세요!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
          ),

        ],
      ),
    );

  }

  var a = SizedBox(
    height: 210,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Card(
              color: Colors.white.withOpacity(0.8),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),

              child: Center(child: Text("빠른 탑승~")),
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,

          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Card(
              color: Colors.white.withOpacity(0.8),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text("시간표 조회")),
            ),
          ),
        ),
      ],
    ),
  );
}

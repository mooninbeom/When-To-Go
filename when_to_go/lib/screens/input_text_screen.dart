import 'package:flutter/material.dart';
import 'package:when_to_go/repository/public_transit_stop.dart';
import 'package:when_to_go/screens/bus/bus_find_screen.dart';
import 'package:when_to_go/screens/bus/seoul_bus_find_screen.dart';
import 'package:when_to_go/screens/subway/subway_find_screen.dart';


class InputTextScreen extends StatefulWidget {
  const InputTextScreen({Key? key, required this.stationClass, required this.isScheduleSearchSelected}) : super(key: key);
  final int stationClass;
  final bool isScheduleSearchSelected;

  @override
  State<InputTextScreen> createState() => _InputTextScreenState();
}

class _InputTextScreenState extends State<InputTextScreen> {
  TextEditingController findSubwayText = TextEditingController();
  dynamic totalCount;
  dynamic trainList;
  dynamic inputText;
  int CID=4000;
  List<bool> isSelected = [false,true, false];
  double contentPaddingValue=20;
  FocusNode _focusNode = FocusNode();
  double searchFieldSize = 100;

  testFunc() async{
    inputText = findSubwayText.text;
    if(inputText.toString().endsWith("역")) inputText = inputText.toString().substring(0,inputText.toString().length-1);


    var a = PublicTransitStop(CID: CID, stationClass: widget.stationClass , stationName: inputText, );
    await a.findPublicTransitStop();

    trainList = a.stationList;
    totalCount = a.totalCount;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Hero(
                    tag: (widget.stationClass==1)?"bus":"subway",
                    child: (widget.stationClass==1)? const Icon(Icons.directions_bus, size: 70,):
                      const Icon(Icons.subway_outlined, size: 70,),
                ),
              ),
              // const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  autofocus: false,
                  focusNode: _focusNode,
                  textAlign: TextAlign.center,
                  controller: findSubwayText,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    inputText = findSubwayText.text;
                    if (widget.stationClass == 2) {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          FindSubwayScreen(
                            CID: CID,
                            inputText: inputText,
                            isScheduleSearchSelected: widget.isScheduleSearchSelected,
                          ),));
                    } else {
                      if(CID==4000||CID==4010) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            FindBusScreen(
                              CID: CID,
                              // stationList: trainList,
                              // totalCount: totalCount,
                              inputText: inputText,
                              isScheduleSearchSelected: widget
                                  .isScheduleSearchSelected,
                            ),));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          SeoulBusFindScreen(busName: inputText)
                          ,));
                      }
                    };
                  },
                  decoration: InputDecoration(
                    hintText: (widget.stationClass==1)?"ex) 성모여성병원건너":"ex) 상인, 반월당...",
                    contentPadding: EdgeInsets.all(contentPaddingValue),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.purple,
                      ),
                    ),

                  ),


                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(onPressed: () {
                  if(widget.stationClass==2) {
                    if(!mounted) return;
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        FindSubwayScreen(
                          CID: CID,
                          inputText: inputText,
                          isScheduleSearchSelected: widget.isScheduleSearchSelected,
                        ),));
                  } else{
                    if(CID==4000||CID==4010) {
                      if (!mounted) return;
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          FindBusScreen(
                            CID: CID,
                            // stationList: trainList,
                            // totalCount: totalCount,
                            inputText: inputText,
                            isScheduleSearchSelected: widget
                                .isScheduleSearchSelected,
                          ),));
                    }else{
                      if(!mounted) return;
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          SeoulBusFindScreen(busName: inputText)
                        ,));
                    }
                  }
                },
                  icon: const Icon(Icons.search),
                ),
              ),
              ToggleButtons(
                  borderColor: Colors.purple,
                  selectedBorderColor: Colors.purple,
                  fillColor: Colors.deepPurple.withOpacity(0.4),
                  selectedColor: Colors.white,
                  splashColor: Colors.deepPurple.withOpacity(0.1),
                  isSelected: isSelected,

                  onPressed: (index){
                    setState(() {
                      if(index==0){
                        isSelected[0] = true;
                        isSelected[1] = false;
                        isSelected[2] = false;
                        CID = 1000;
                      }else if(index==1){
                        isSelected[0] = false;
                        isSelected[1] = true;
                        isSelected[2] = false;
                        CID = 4000;
                      }else{
                        isSelected[0] = false;
                        isSelected[1] = false;
                        isSelected[2] = true;
                        CID = 4010;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("서울", style: TextStyle(fontSize: 17,),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("대구", style: TextStyle(fontSize: 17,),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("경산", style: TextStyle(fontSize: 17,),),
                    ),
                  ],

              )
            ],
          )
      ),
    );
  }



}

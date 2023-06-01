import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';
import 'package:when_to_go/screens/POI_search_screen.dart';
import 'package:when_to_go/screens/bookmarked_screen.dart';
import 'package:when_to_go/screens/input_text_screen.dart';
import 'package:when_to_go/screens/onboarding_screen.dart';
import 'package:when_to_go/screens/select_subway_bus_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:when_to_go/repository/notification.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isFirst = true;

void main() async{
  await Hive.initFlutter();
  await Hive.openBox("bookmark");
  await Hive.openBox("isFirst");
  if (Hive.box("isFirst").isEmpty){
    Hive.box("isFirst").put("isFirst", true);
  } else{
    isFirst = Hive.box("isFirst").get("isFirst");
  }

  if(await Permission.location.isDenied){
    await Permission.location.request();
  }

  var firstScreen;
  if(isFirst){
    Hive.box("isFirst").put("isFirst", false);
    isFirst = !isFirst;
    firstScreen = const OnboardingScreen();
  }else{
    firstScreen = MyApp();
  }


  // var location = await Location().getLocation();
  // double? nowLatitude = location.latitude;
  // double? nowLongitude = location.longitude;

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: navigatorKey,
      home: firstScreen,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          )
        )
      ),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key,}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  // double? nowLatitude = 35.8183;
  // double? nowLongitude = 128.536;
}

class _MyAppState extends State<MyApp> {


  // getPermission() async{
  //   await Permission.location.request();
  //   var a = await POIPublicTransitStop(centerLon:128.536, centerLat: 35.8183).getPOIPublicTransitStop();
  //
  //   print(a);
  // }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var a = FlutterNotification();
    a.requestNotificationPermission();
    // getPermission();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Flexible(flex:1,child: SizedBox()),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.purple.withOpacity(0.7),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const InputTextScreen(
                          isScheduleSearchSelected: false,
                          stationClass: 2,
                        ),));
                      },
                      child: SizedBox(
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const[
                              Icon(Icons.search, size: 40,),
                              Text("키워드로 찾기"),
                            ],
                          ),
                      ),
                  ),
                ),
                // const Flexible(flex: 1,child: SizedBox()),
                Flexible(
                  flex:3,
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      backgroundColor: Colors.purple.withOpacity(0.7),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async{
                      geo.Position position = await geo.Geolocator.getCurrentPosition(
                          desiredAccuracy: geo.LocationAccuracy.bestForNavigation
                      );
                      double lat = position.latitude;
                      double lon = position.longitude;
                      if(!mounted) return;
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          POISearchScreen(lat: lat, lon: lon,)
                        ,));
                    },
                    child: SizedBox(
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const[
                            Icon(Icons.map_outlined, size: 40,),
                            Text("지도로 찾기"),
                          ],
                        )),
                  ),
                ),
                const Flexible(flex:1,child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 30,),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Flexible(flex:1, child: SizedBox()),
                Flexible(
                    flex: 8,
                    fit: FlexFit.tight,
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectBusSubScreen(isScheduleSearchSelected: true),));
                        },
                        child: SizedBox(
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const[
                                Icon(Icons.schedule, size: 40,),
                                SizedBox(height: 10,),
                                Text("시간표 조회"),
                              ],
                            )
                        ),
                ),
                    )),
                const Flexible(flex:1, child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 30,),
          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Flexible(flex:1, child: SizedBox()),
                  Flexible(
                      flex: 8,
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            const BookmarkedScreen(),));
                        },
                        child: SizedBox(
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const[
                              Icon(Icons.star, size: 40,),
                              SizedBox(height: 10,),
                              Text("즐겨찾기")
                            ],
                          ),
                        ),
                  )),
                  const Flexible(flex:1, child: SizedBox())
                ],
              )
          ),
          TextButton(onPressed: (){Hive.box("bookmark").clear();}, child: Text("초기화")),
          // TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));}, child: const Text("테스트2")),
          const Flexible(flex: 2,child: SizedBox())
        ],
      )
    );

  }
}

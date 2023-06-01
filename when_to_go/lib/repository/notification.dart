import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;





class FlutterNotification{


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


  init() async{
    // AndroidInitializationSettings androidInitializationSettings =
    //     const AndroidInitializationSettings("assets/대구 1호선.svg");

    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings(
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        );

    InitializationSettings initializationSettings =
        InitializationSettings(
          // android: androidInitializationSettings,
          iOS: darwinInitializationSettings
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  requestNotificationPermission(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showNotification(String stationName, int minute) async{
    // const AndroidNotificationDetails androidNotificationDetails =
    //     AndroidNotificationDetails("channelId", "channelName",
    //       channelDescription: "channel description",
    //       importance: Importance.max,
    //       priority: Priority.max,
    //       showWhen: false,
    //     );

    const NotificationDetails notificationDetails =
        NotificationDetails(
          iOS: DarwinNotificationDetails(badgeNumber: 1),
          // android: androidNotificationDetails,
        );

    await flutterLocalNotificationsPlugin.show(
        123, "지금 출발하세요!", "$stationName역 까지 걸리는 시간은 $minute분 입니다.", notificationDetails
    );
  }

  showNotificationLater(String stationName, int totalTime, int offsetMinute) async{
    tz.initializeTimeZones();

    var iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );

    flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        "지금 출발하세요!",
        "$stationName역 까지 걸리는 시간은 $totalTime분 입니다.",
        tz.TZDateTime.now(tz.local).add(Duration(minutes: offsetMinute)),
        NotificationDetails(iOS: iosDetails),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );

  }


}
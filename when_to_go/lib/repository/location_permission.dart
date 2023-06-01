import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';


class GetLocation{

  Future<List<double?>> getPermissionAndLocation() async{
    await Permission.location.request();
    var status = await Permission.location.status;
    if(status.isGranted){
      var location = await Location().getLocation();
      print(location.altitude);

      var now_x = location.longitude;
      var now_y = location.latitude;
      return [now_x, now_y];
    }else if(status.isDenied){
      openAppSettings();
      return [];
    }
    return [];
  }

}
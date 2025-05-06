import 'package:geolocator/geolocator.dart';
import 'package:map/models.dart';

abstract class AppLocation{
  Future<AppLatLong> getCurrentLocation();
  Future<bool> requestPermission();
  Future<bool> checkPermission();

}


class LocationService implements AppLocation{
  final defLocation = MoscowLocation();
  @override
  Future<bool> checkPermission() {
    // TODO: implement checkPermission
    return Geolocator.checkPermission().then((value)=>
       value == LocationPermission.always || value == LocationPermission.whileInUse
    ).catchError((_)=> false);
  }

  @override
  Future<AppLatLong> getCurrentLocation() {
   return Geolocator.getCurrentPosition().then((value){
     return AppLatLong(lat: value.latitude, long: value.longitude);
   }).catchError((_)=> defLocation);
  }

  @override
  Future<bool> requestPermission() {
    // TODO: implement requestPermission
    return Geolocator.requestPermission().then((value)=>
    value == LocationPermission.always || value == LocationPermission.whileInUse
    ).catchError((_)=> false);
  }

}
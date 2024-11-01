import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Map<String, dynamic>> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check location is on
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        'serviceEnabled': false,
      };
    }

    // check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          'permission': false,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        'permission': false,
      };
    }

    print("BU YERGA KELDI");

    return {
      'serviceEnabled': true,
      'permission': true,
      'position': await Geolocator.getCurrentPosition()
    };
  }
}

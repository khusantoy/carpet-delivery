import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _lastPosition;
  DateTime? _lastFetchTime;

  Future<Map<String, dynamic>> getLocation() async {
    if (_lastPosition != null && _lastFetchTime != null) {
      final difference = DateTime.now().difference(_lastFetchTime!);
      if (difference.inMinutes < 1) {
        return {
          'serviceEnabled': true,
          'permission': true,
          'position': _lastPosition
        };
      }
    }

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {'serviceEnabled': false};
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {'permission': false};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {'permission': false};
    }

    final position = await Geolocator.getCurrentPosition();
    _lastPosition = position;
    _lastFetchTime = DateTime.now();

    return {'serviceEnabled': true, 'permission': true, 'position': position};
  }
}

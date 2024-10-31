import 'package:carpet_delivery/data/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // late YandexMapController mapController;
  Position? _currentPosition;

  @override
  void initState() {
    LocationService.getLocation().then((value) {
      setState(() {
        _currentPosition = value;
      });
    });

    super.initState();
  }

  // void onMapCreated(YandexMapController controller) {
  //   _getCurrentLocation();
  //   mapController = controller;
  //   mapController.moveCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: muCurrentLocation!, zoom: 15),
  //     ),
  //   );
  //   setState(() {});
  // }

  // void onCameraPositionChanged(
  //   CameraPosition position,
  //   CameraUpdateReason reason,
  //   bool finished,
  // ) {
  //   if (finished) {
  //     muCurrentLocation = position.target;
  //     setState(() {});
  //   }
  // }

  // void _getCurrentLocation() async {
  //   final position = await Geolocator.getCurrentPosition(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 10,
  //     ),
  //   );
  //   setState(() {
  //     _currentPosition = position;
  //     muCurrentLocation = Point(
  //       latitude: _currentPosition.latitude,
  //       longitude: _currentPosition.longitude,
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print(_currentPosition);
    return Scaffold(
      body: YandexMap(
          // onMapCreated: onMapCreated,
          // onCameraPositionChanged: onCameraPositionChanged,
          // mapObjects: [
          //   if (muCurrentLocation != null)
          //     PlacemarkMapObject(
          //       mapId: const MapObjectId("user_location"),
          //       point: muCurrentLocation!,
          //       icon: PlacemarkIcon.single(
          //         PlacemarkIconStyle(
          //           image: BitmapDescriptor.fromAssetImage(
          //             "assets/images/user.png",
          //           ),
          //         ),
          //       ),
          //     ),
          //   PlacemarkMapObject(
          //     mapId: const MapObjectId("najottalim"),
          //     point: najotTalim,
          //     icon: PlacemarkIcon.single(
          //       PlacemarkIconStyle(
          //         image: BitmapDescriptor.fromAssetImage(
          //           "assets/images/najottalim.png",
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController mapController;

  void onMapCreated(YandexMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: onMapCreated,
        mapObjects: [
          PlacemarkMapObject(
            mapId: const MapObjectId("najottalim"),
            point: const Point(latitude: 41.285717, longitude: 69.203606),
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  "assets/images/navigator.png",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

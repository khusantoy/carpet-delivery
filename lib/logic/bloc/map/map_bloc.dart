import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:carpet_delivery/data/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  OrderRepository orderRepository;
  MapBloc(this.orderRepository) : super(InitialMapState()) {
    on<GetOrderMarkersMapEvent>(_getOrderMarkers);
    on<ServiceDisabledMapEvent>(_onServiceDisabled);
    on<LocationPermissionDeniedMapEvent>(_onPermissionDenied);
  }

  void _getOrderMarkers(GetOrderMarkersMapEvent event, emit) async {
    emit(LoadingMapState());

    try {
      final orders = await orderRepository.getReadyOrders();
      final locationService = LocationService();

      final result = await locationService.getLocation();

      if (result['serviceEnabled'] == false) {
        emit(ServiceDisabledMapState());
        return;
      }

      if (result['permission'] == false) {
        emit(PermissionDeniedMapState());
        return;
      }

      List<PlacemarkMapObject> markers = [];

      final Position myPosition = result['position'];
      final Point myPoint = Point(
        latitude: myPosition.latitude,
        longitude: myPosition.longitude,
      );

      markers.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('my_position'),
          point: myPoint,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/images/user.png',
              ),
            ),
          ),
          text: const PlacemarkText(
            text: "Men",
            style: PlacemarkTextStyle(
              placement: TextStylePlacement.top,
            ),
          ),
        ),
      );

      for (var order in orders) {
        final orderPoint = Point(
          latitude: order.client.latitude,
          longitude: order.client.longitude,
        );

        final distance = calculateDistance(
          myPoint.latitude,
          myPoint.longitude,
          orderPoint.latitude,
          orderPoint.longitude,
        );

        final duration = calculateDuration(distance);

        markers.add(
          PlacemarkMapObject(
            mapId: MapObjectId(order.id),
            point: orderPoint,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/images/route_start.png',
                ),
              ),
            ),
            text: PlacemarkText(
              text: order.client.phoneNumber,
              style: const PlacemarkTextStyle(
                placement: TextStylePlacement.top,
                size: 8,
              ),
            ),
            onTap: (mapObject, point) {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                showDragHandle: true,
                context: event.context,
                builder: (context) => Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(order.client.fullName),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone_android),
                        title: Text(order.client.phoneNumber),
                        trailing: IconButton.outlined(
                          onPressed: () {
                            launchUrl(
                                Uri.parse('tel:${order.client.phoneNumber}'));
                          },
                          icon: const Icon(Icons.phone),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(order.address),
                        trailing: IconButton.outlined(
                          onPressed: () async {
                            final yandexUrl = Uri.parse(
                                'yandexmaps://maps.yandex.ru/?'
                                'pt=${order.client.latitude},${order.client.longitude}' // nuqta koordinatalari
                                '&z=14' // zoom darajasi (0-21)
                                '&text=${Uri.encodeComponent(order.address)}' // marker matni
                                );

                            if (await canLaunchUrl(yandexUrl)) {
                              await launchUrl(yandexUrl);
                            } else {
                              toastification.show(
                                context: context,
                                title: const Text("Yandex Map topilmadi"),
                                type: ToastificationType.error,
                                autoCloseDuration: const Duration(seconds: 3),
                                showProgressBar: false,
                                closeButtonShowType: CloseButtonShowType.none,
                              );
                            }
                          },
                          icon: const Icon(Icons.navigation_rounded),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.near_me),
                        title: Text(
                          '${distance.toStringAsFixed(2)} km',
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.timer),
                        title: Text("$duration daqiqa"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }

      emit(LoadedMapState(markers: markers, point: myPoint));
    } catch (e) {
      ErrorMapState(message: e.toString());
    }
  }

  void _onServiceDisabled(ServiceDisabledMapEvent event, emit) {
    emit(ServiceDisabledMapState());
  }

  void _onPermissionDenied(LocationPermissionDeniedMapEvent event, emit) {
    emit(PermissionDeniedMapState());
  }

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const double earthRadius = 6371;
    final double latDiff = _toRadians(endLat - startLat);
    final double lngDiff = _toRadians(endLng - startLng);

    final double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(_toRadians(startLat)) *
            cos(_toRadians(endLat)) *
            sin(lngDiff / 2) *
            sin(lngDiff / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  int calculateDuration(double distance) {
    const averageSpeed = 40;
    return (distance / averageSpeed * 60).round();
  }
}

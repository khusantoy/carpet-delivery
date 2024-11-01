import 'dart:async';

import 'package:carpet_delivery/logic/bloc/map/map_bloc.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  YandexMapController? mapController;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  StreamSubscription? _permissionStatusStreamSubscription;
  LocationPermission? _lastPermissionStatus;

  void listenToLocationService() {
    _serviceStatusStreamSubscription =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        if (mounted) {
          context.read<MapBloc>().add(ServiceDisabledMapEvent());
        }
      } else if (status == ServiceStatus.enabled) {
        if (mounted) {
          context
              .read<MapBloc>()
              .add(GetOrderMarkersMapEvent(context: context));
        }
      }
    });
  }

  void listenToLocationPermission() {
    _permissionStatusStreamSubscription =
        Stream.periodic(const Duration(seconds: 3)).listen((_) async {
      if (mounted) {
        final currentPermission = await Geolocator.checkPermission();

        // Faqat permission o'zgargan bo'lsagina event yuboramiz
        if (_lastPermissionStatus != currentPermission) {
          _lastPermissionStatus = currentPermission;

          if (mounted) {
            switch (currentPermission) {
              case LocationPermission.denied:
              case LocationPermission.deniedForever:
              case LocationPermission.unableToDetermine:
                context.read<MapBloc>().add(LocationPermissionDeniedMapEvent());
                break;
              case LocationPermission.whileInUse:
              case LocationPermission.always:
                context
                    .read<MapBloc>()
                    .add(GetOrderMarkersMapEvent(context: context));
                break;
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    listenToLocationService();
    listenToLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    _serviceStatusStreamSubscription?.cancel();
    _permissionStatusStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xarita"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: BlocBuilder<MapBloc, MapState>(
        bloc: context.read<MapBloc>()
          ..add(GetOrderMarkersMapEvent(context: context)),
        builder: (context, state) {
          if (state is LoadingMapState) {
            return Center(
              child: Lottie.asset("assets/map.json"),
            );
          }

          if (state is ErrorMapState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ServiceDisabledMapState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Sizda GPS o'chirilgan ko'rinadi. Iltimos, GPS yoqilganligini tekshiring.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.customBlack,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Geolocator.openLocationSettings();
                    },
                    child: const Text("Sozlamalarni ochish"),
                  ),
                ],
              ),
            );
          }

          if (state is PermissionDeniedMapState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Joylashuv xizmati uchun ruxsat bermagansiz. Sozlamalarga kirib, ruxsat bering.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.customBlack,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Geolocator.openAppSettings();
                    },
                    child: const Text("Sozlamalarni ochish"),
                  ),
                ],
              ),
            );
          }

          if (state is LoadedMapState) {
            return YandexMap(
              onMapCreated: (YandexMapController controller) {
                mapController = controller;
                mapController!.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: state.point,
                      zoom: 12,
                    ),
                  ),
                );
              },
              mapObjects: state.markers,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

part of 'map_bloc.dart';

sealed class MapState {}

class InitialMapState extends MapState {}

class LoadingMapState extends MapState {}

class LoadedMapState extends MapState {
  List<PlacemarkMapObject> markers;
  Point point;

  LoadedMapState({required this.markers, required this.point});
}

class ErrorMapState extends MapState {
  String message;

  ErrorMapState({required this.message});
}

class ServiceDisabledMapState extends MapState {}

class PermissionDeniedMapState extends MapState {}

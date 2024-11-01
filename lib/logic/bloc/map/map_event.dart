part of 'map_bloc.dart';

sealed class MapEvent {}

class GetOrderMarkersMapEvent extends MapEvent {}

class ServiceDisabledMapEvent extends MapEvent {}

class LocationPermissionDeniedMapEvent extends MapEvent {}

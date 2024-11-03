part of 'map_bloc.dart';

sealed class MapEvent {}

class GetOrderMarkersMapEvent extends MapEvent {
  BuildContext context;

  GetOrderMarkersMapEvent({required this.context});
}

class ServiceDisabledMapEvent extends MapEvent {
  
}

class LocationPermissionDeniedMapEvent extends MapEvent {}
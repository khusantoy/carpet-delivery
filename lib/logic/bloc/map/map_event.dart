part of 'map_bloc.dart';

sealed class MapEvent {}

class GetOrderMarkersMapEvent extends MapEvent {
  BuildContext context;

  GetOrderMarkersMapEvent({required this.context});
}

class ServiceDisabledMapEvent extends MapEvent {
  
}

class LocationPermissionDeniedMapEvent extends MapEvent {}

class SetActiveOrderMapEvent extends MapEvent {
  final String orderId;
  final BuildContext context;
  final double distance;
  final int duration;

  SetActiveOrderMapEvent({
    required this.orderId,
    required this.context,
    required this.distance,
    required this.duration,
  });
}
import 'package:bloc/bloc.dart';
import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:carpet_delivery/data/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
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

      final result = await LocationService.getLocation();

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
        ),
      );

      for (var order in orders) {
        markers.add(
          PlacemarkMapObject(
            mapId: MapObjectId(order.id),
            point: Point(
              latitude: order.client.latitude,
              longitude: order.client.longitude,
            ),
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/images/route_start.png',
                ),
              ),
            ),
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
}

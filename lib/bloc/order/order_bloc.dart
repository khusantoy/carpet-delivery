import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpet_delivery/data/models/order/order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(InitialOrderState()) {
    on<GetOrdersEvent>(_onGetOrders);
    on<GetAllOrdersEvent>(_onGetAllOrders);
    on<GetReadyOrdersEvent>(_onGetReadyOrders);
    on<GetDeliveringOrdersEvent>(_onGetDeliveringOrders);
    on<GetDeliveredOrdersEvent>(_onGetDeliveredOrders);
    on<ChangeStatusOrdersEvent>(_onChangeStatus);
  }

  Future<void> _onGetOrders(
    GetOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(LoadingOrderState());
    try {
      final orders = await orderRepository.getAllOrder();

      emit(
        LoadedOrderState(
          allOrders: orders,
          filteredOrders: orders,
          count: orders.length,
          title: "Barchasi",
          x: 1.4,
          y: -1,
        ),
      );
    } catch (e) {
      emit(ErrorOrderState(e.toString()));
    }
  }

  void _onGetAllOrders(
    GetAllOrdersEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state is LoadedOrderState) {
      try {
        final currentState = state as LoadedOrderState;
        final allOrders = currentState.allOrders;

        emit(
          LoadedOrderState(
            allOrders: allOrders,
            filteredOrders: allOrders,
            title: "Barchasi",
            count: allOrders.length,
            x: 1.4,
            y: -1,
          ),
        );
      } catch (e) {
        emit(ErrorOrderState(e.toString()));
      }
    }
  }

  void _onGetReadyOrders(
    GetReadyOrdersEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state is LoadedOrderState) {
      try {
        final currentState = state as LoadedOrderState;
        final allOrders = currentState.allOrders;

        final filteredOrdes =
            allOrders.where((order) => order.status == 'READY').toList();
        emit(
          LoadedOrderState(
            allOrders: allOrders,
            filteredOrders: filteredOrdes,
            count: filteredOrdes.length,
            title: "Yetkazilmagan",
            x: 1.2,
            y: -1,
          ),
        );
      } catch (e) {
        emit(ErrorOrderState(e.toString()));
      }
    }
  }

  void _onGetDeliveringOrders(
    GetDeliveringOrdersEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state is LoadedOrderState) {
      try {
        final currentState = state as LoadedOrderState;
        final allOrders = currentState.allOrders;

        final filteredOrdes =
            allOrders.where((order) => order.status == 'DELIVERING').toList();
        emit(
          LoadedOrderState(
            allOrders: allOrders,
            filteredOrders: filteredOrdes,
            count: filteredOrdes.length,
            title: "Yetkazilmoqda",
            x: 1.2,
            y: -1,
          ),
        );
      } catch (e) {
        emit(ErrorOrderState(e.toString()));
      }
    }
  }

  void _onGetDeliveredOrders(
    GetDeliveredOrdersEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state is LoadedOrderState) {
      try {
        final currentState = state as LoadedOrderState;
        final allOrders = currentState.allOrders;

        final filteredOrdes =
            allOrders.where((order) => order.status == 'DELIVERED').toList();
        emit(
          LoadedOrderState(
            allOrders: allOrders,
            filteredOrders: filteredOrdes,
            count: filteredOrdes.length,
            title: "Yetkazilgan",
            x: 1.3,
            y: -1,
          ),
        );
      } catch (e) {
        emit(ErrorOrderState(e.toString()));
      }
    }
  }

  void _onChangeStatus(ChangeStatusOrdersEvent event, emit) {
    if (state is LoadedOrderState) {
      try {
        final currentState = state as LoadedOrderState;
        final allOrders = currentState.allOrders;
        List<Order> filteredOrders = currentState.filteredOrders;

        final indexInAll =
            allOrders.indexWhere((order) => order.id == event.orderId);
        final indexInFiltered =
            filteredOrders.indexWhere((order) => order.id == event.orderId);

        if (indexInFiltered != -1 && indexInAll != -1) {
          final orderInAll = allOrders[indexInAll];
          final orderInFiltered = filteredOrders[indexInFiltered];

          allOrders[indexInAll] = orderInAll.copyWith(status: event.status);
          filteredOrders[indexInFiltered] =
              orderInFiltered.copyWith(status: event.status);

          if (currentState.title == 'Yetkazilmagan') {
            filteredOrders =
                allOrders.where((order) => order.status == 'READY').toList();
          } else if (currentState.title == 'Yetkazilmoqda') {
            filteredOrders = allOrders
                .where((order) => order.status == 'DELIVERING')
                .toList();
          } else if (currentState.title == 'Yetkazilgan') {
            filteredOrders = allOrders
                .where((order) => order.status == 'DELIVERED')
                .toList();
          }

          emit(
            LoadedOrderState(
              allOrders: allOrders,
              filteredOrders: filteredOrders,
              title: currentState.title,
              count: filteredOrders.length,
              x: currentState.x,
              y: currentState.y,
            ),
          );
        }
      } catch (e) {
        emit(ErrorOrderState(e.toString()));
      }
    }
  }
}

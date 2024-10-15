import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpet_delivery/data/models/order/order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(InitialOrderState()) {
    on<GetAllOrdersEvent>(_onGetAllOrders);
    on<GetReadyOrdersEvent>(_onGetReadyOrders);
    on<GetDeliveringOrdersEvent>(_onGetDeliveringOrders);
    on<GetDeliveredOrdersEvent>(_onGetDeliveredOrders);
  }

  Future<void> _onGetAllOrders(
    GetAllOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(LoadingOrderState());
    try {
      final orders = await orderRepository.getAllOrder();
      emit(LoadedOrderState(orders: orders));
    } catch (e) {
      emit(ErrorOrderState(e.toString()));
    }
  }

  Future<void> _onGetReadyOrders(
    GetReadyOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(LoadingOrderState());
    try {
      final orders = await orderRepository.getReadyOrders();
      emit(LoadedOrderState(orders: orders));
    } catch (e) {
      emit(ErrorOrderState(e.toString()));
    }
  }

  Future<void> _onGetDeliveringOrders(
    GetDeliveringOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(LoadingOrderState());
    try {
      final orders = await orderRepository.getDeliveringOrders();
      emit(LoadedOrderState(orders: orders));
    } catch (e) {
      emit(ErrorOrderState(e.toString()));
    }
  }

  Future<void> _onGetDeliveredOrders(
    GetDeliveredOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(LoadingOrderState());
    try {
      final orders = await orderRepository.getDeliveredOrders();
      emit(LoadedOrderState(orders: orders));
    } catch (e) {
      emit(ErrorOrderState(e.toString()));
    }
  }
}

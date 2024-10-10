import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpet_delivery/data/models/order/order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(InitialOrderState()) {
    on<GetOrderEvent>(_onGetOrders);
  }

  Future<void> _onGetOrders(
    GetOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(LoadingOrderState());
    try {
      final orders =
          await orderRepository.getOrder(page: event.page, limit: event.limit);
      emit(LoadedOrderState(orders: orders));
    } catch (e) {
      emit(ErrorOrderState(e.toString()));
    }
  }
}

import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final OrderRepository orderRepository;
  StatusBloc({required this.orderRepository}) : super(InitialStatusState()) {
    on<ChangeStatusEvent>(_onChangeStatus);
  }

  Future<void> _onChangeStatus(ChangeStatusEvent event, emit) async {
    emit(LoadingStatusState(orderId: event.orderId));
    try {
      final response = await orderRepository.changeOrderStatus(
        orderId: event.orderId,
        status: event.status,
      );
      emit(LoadedStatusState(isSuccess: response, status: event.status, orderId: event.orderId));
    } catch (e) {
      print("STATUS BLOC ERROR => $e");
      emit(ErrorStatusState(message: e.toString()));
    }
  }
}

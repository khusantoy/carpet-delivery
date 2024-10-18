part of 'order_bloc.dart';

sealed class OrderEvent {}

class GetOrdersEvent extends OrderEvent {}

class GetAllOrdersEvent extends OrderEvent {}

class GetReadyOrdersEvent extends OrderEvent {}

class GetDeliveringOrdersEvent extends OrderEvent {}

class GetDeliveredOrdersEvent extends OrderEvent {}

class ChangeStatusOrdersEvent extends OrderEvent {
  final String status;
  final String orderId;

  ChangeStatusOrdersEvent({required this.status, required this.orderId});
}

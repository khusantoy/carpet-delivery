part of 'order_bloc.dart';

sealed class OrderEvent {}

class GetAllOrdersEvent extends OrderEvent {}

class GetReadyOrdersEvent extends OrderEvent {}

class GetDeliveringOrdersEvent extends OrderEvent {}

class GetDeliveredOrdersEvent extends OrderEvent {}

part of 'order_bloc.dart';

sealed class OrderState {}

class InitialOrderState extends OrderState {}

class LoadingOrderState extends OrderState {}

class LoadedOrderState extends OrderState {
  List<Order> orders;

  LoadedOrderState({required this.orders});
}

class ErrorOrderState extends OrderState {
  String message;

  ErrorOrderState(this.message);
}

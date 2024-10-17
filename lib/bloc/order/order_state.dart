part of 'order_bloc.dart';

sealed class OrderState {}

class InitialOrderState extends OrderState {}

class LoadingOrderState extends OrderState {}

class LoadedOrderState extends OrderState {
  List<Order> allOrders;
  List<Order> filteredOrders;
  String title;
  int count;
  double x;
  double y;

  LoadedOrderState({
    required this.allOrders,
    required this.filteredOrders,
    required this.title,
    required this.count,
    required this.x,
    required this.y,
  });
}

class ErrorOrderState extends OrderState {
  String message;

  ErrorOrderState(this.message);
}

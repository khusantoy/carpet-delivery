part of 'order_bloc.dart';

sealed class OrderState {}

class InitialOrderState extends OrderState {}

class LoadingOrderState extends OrderState {
  final String? lastTitle;
  final double? x;
  final double? y;

  LoadingOrderState({required this.lastTitle, required this.x, required this.y});
}

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

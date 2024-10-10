part of 'order_bloc.dart';

sealed class OrderEvent {}

class GetOrderEvent extends OrderEvent {
  int page;
  int limit;

  GetOrderEvent({
    required this.page,
    required this.limit,
  });
}

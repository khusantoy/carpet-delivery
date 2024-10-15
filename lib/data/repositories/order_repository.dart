import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:carpet_delivery/data/services/order_service.dart';

class OrderRepository {
  final OrderService orderService;

  OrderRepository({required this.orderService});

  Future<List<Order>> getAllOrder() async {
    return await orderService.getAllOrders();
  }

  Future<List<Order>> getReadyOrders() async {
    return await orderService.getReadyOrders();
  }

  Future<List<Order>> getDeliveringOrders() async {
    return await orderService.getDeliveringOrders();
  }

  Future<List<Order>> getDeliveredOrders() async {
    return await orderService.getDeliveredOrders();
  }
}

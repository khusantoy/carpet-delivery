import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:carpet_delivery/data/services/order_service.dart';

class OrderRepository {
  final OrderService orderService;

  OrderRepository({required this.orderService});

  Future<List<Order>> getOrder({required int page, required int limit}) async {
    return await orderService.getAllOrders(page: page, limit: limit);
  }
}

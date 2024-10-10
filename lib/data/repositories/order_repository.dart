import 'package:carpet_delivery/data/services/order_service.dart';

class OrderRepository {
  final OrderService orderService;

  OrderRepository({required this.orderService});

  Future<void> getOrder({required int page, required int limit}) async {
    await orderService.getOrder(page: page, limit: limit);
  }
}

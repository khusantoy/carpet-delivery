import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/dio_network.dart';
import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:dio/dio.dart';

class OrderService {
  final _dio = getIt.get<DioNetwork>().dio;

  Future<List<Order>> getOrder({required int page, required int limit}) async {
    try {
      final response = await _dio.get("/api/courier_orders", queryParameters: {
        "page": page,
        "limit": limit,
      });

      List<Order> orders = [];

      for (var order in response.data['data']['orders']) {
        orders.add(Order.fromJson(order));
      }

      print(orders.length);
      return orders;
    } on DioException catch (e) {
      print("ORDER DIO EXCEPTION: $e");
      rethrow;
    } catch (e) {
      print("ORDER EXCEPTION: $e");
      rethrow;
    }
  }
}

import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/dio_network.dart';
import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:dio/dio.dart';

class OrderService {
  final _dio = getIt.get<DioNetwork>().dio;

  Future<List<Order>> getOrder({required int page, required int limit}) async {
    try {
      List<dynamic> allOrders = [];
      List<Order> orders = [];

      while (true) {
        final response = await _dio.get("/api/orders", queryParameters: {
          "page": page,
          "limit": limit,
        });

        List<dynamic> orders = response.data['data']['orders'];
        allOrders.addAll(orders);

        int totalCount = response.data['data']['total_count'];

        int totalPages = (totalCount / limit).ceil();

        if (page >= totalPages) {
          break;
        }

        page++;
      }

      for (var order in allOrders) {
        orders.add(Order.fromJson(order));
      }

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

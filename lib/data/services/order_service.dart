import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/dio_network.dart';
import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:dio/dio.dart';

class OrderService {
  final _dio = getIt.get<DioNetwork>().dio;

  Future<List<Order>> getAllOrders() async {
    try {
      List<Order> orders = [];

      final readyOrders = await getReadyOrders();
      final deliveringOrders = await getDeliveredOrders();
      final deliveredOrders = await getDeliveredOrders();

      orders.addAll(readyOrders);
      orders.addAll(deliveringOrders);
      orders.addAll(deliveredOrders);

      return orders;
    } catch (e) {
      print("ALL ORDER EXCEPTION: $e");
      rethrow;
    }
  }

  Future<List<Order>> getReadyOrders() async {
    try {
      int page = 1;
      List<dynamic> allOrders = [];
      List<Order> orders = [];

      while (true) {
        final response = await _dio.get("/api/orders", queryParameters: {
          "page": page,
          "limit": 10,
          "status": "READY",
        });

        List<dynamic> orders = response.data['data']['orders'];
        allOrders.addAll(orders);

        int totalCount = response.data['data']['total_count'];

        int totalPages = (totalCount / 10).ceil();

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
      print("READY ORDER DIO EXCEPTION: $e");
      rethrow;
    } catch (e) {
      print("READY ORDER EXCEPTION: $e");
      rethrow;
    }
  }

  Future<List<Order>> getDeliveringOrders() async {
    try {
      int page = 1;
      List<dynamic> allOrders = [];
      List<Order> orders = [];

      while (true) {
        final response = await _dio.get("/api/orders", queryParameters: {
          "page": page,
          "limit": 10,
          "status": "DELIVERING",
        });

        List<dynamic> orders = response.data['data']['orders'];
        allOrders.addAll(orders);

        int totalCount = response.data['data']['total_count'];

        int totalPages = (totalCount / 10).ceil();

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
      print("DELIVERING ORDER DIO EXCEPTION: $e");
      rethrow;
    } catch (e) {
      print("DELIVERING ORDER EXCEPTION: $e");
      rethrow;
    }
  }

  Future<List<Order>> getDeliveredOrders() async {
    try {
      int page = 1;
      List<dynamic> allOrders = [];
      List<Order> orders = [];

      while (true) {
        final response = await _dio.get("/api/orders", queryParameters: {
          "page": page,
          "limit": 10,
          "status": "DELIVERED",
        });

        List<dynamic> orders = response.data['data']['orders'];
        allOrders.addAll(orders);

        int totalCount = response.data['data']['total_count'];

        int totalPages = (totalCount / 10).ceil();

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
      print("DELIVERED ORDER DIO EXCEPTION: $e");
      rethrow;
    } catch (e) {
      print("DELIVERED ORDER EXCEPTION: $e");
      rethrow;
    }
  }
}

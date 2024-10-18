import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/dio_network.dart';
import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderService {
  final _dio = getIt.get<DioNetwork>().dio;

  Future<List<Order>> getAllOrders() async {
    try {
      List<Order> orders = [];

      final readyOrders = await getReadyOrders();
      final deliveringOrders = await getDeliveringOrders();
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

        if (response.statusCode == 500) {
          return [];
        }

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
        double latitude = order['client']['latitude'];
        double longitude = order['client']['longitude'];

        final res =
            await geocoder(latitude: latitude, longitude: longitude);

        order['address'] = res['address'];
        order['url'] = res['url'];
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

        if (response.statusCode == 500) {
          return [];
        }

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
        double latitude = order['client']['latitude'];
        double longitude = order['client']['longitude'];

        final res =
            await geocoder(latitude: latitude, longitude: longitude);

        order['address'] = res['address'];
        order['url'] = res['url'];
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
        double latitude = order['client']['latitude'];
        double longitude = order['client']['longitude'];

        final res =
            await geocoder(latitude: latitude, longitude: longitude);

        order['address'] = res['address'];
        order['url'] = res['url'];
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

  Future<bool> changeOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await _dio.put(
        '/api/order_status/$orderId',
        queryParameters: {
          "status": status,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("CHANGE ORDER STATUS: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> geocoder({
    required double latitude,
    required double longitude,
  }) async {
    final geoDio = Dio();
    final apiKey = dotenv.env['YANDEX_GEOCODER_API'];

    try {
      final response = await geoDio.get(
          "https://geocode-maps.yandex.ru/1.x/?apikey=$apiKey&geocode=$latitude,$longitude&lang=uz_UZ&format=json");

      final address1 = response.data['response']['GeoObjectCollection']
              ['featureMember'][0]['GeoObject']['metaDataProperty']
          ['GeocoderMetaData']['text'];

      final List addressTwoFutureMember =
          response.data['response']['GeoObjectCollection']['featureMember'];

      final url = response.data['response']['GeoObjectCollection']
          ['featureMember'][0]['GeoObject']['uri'];

      if (addressTwoFutureMember.length > 2) {
        String address2 = addressTwoFutureMember[2]['GeoObject']
            ['metaDataProperty']['GeocoderMetaData']['text'];

        List<String> list1 = address1.split(',');
        List<String> list2 = address2.split(',');

        List<String> list3 = [...list1, ...list2];
        Set<String> uniqueList = list3.toSet();
        List<String> res = uniqueList.toList().sublist(1);

        return {
          'address': res.join(",").trim(),
          'url': url,
        };
      }

      return {
        'address': address1,
        'url': url,
      };
    } catch (e) {
      print("GEOCODER ERROR => $e");
      rethrow;
    }
  }
}

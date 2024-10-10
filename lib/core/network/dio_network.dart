import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:dio/dio.dart';

class DioNetwork {
  late final Dio _dio;

  DioNetwork({required Dio dio}) {
    _dio = dio;
    _dio.options.baseUrl = "http://18.194.52.136:8080";
    _dio.interceptors.add(NetworkInterceptor());
  }

  Dio get dio => _dio;
}

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authLocalService = getIt.get<AuthLocalService>();
    final token = authLocalService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }
}

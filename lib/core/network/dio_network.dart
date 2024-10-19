import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/services/auth_api_service.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:dio/dio.dart';

class DioNetwork {
  late final Dio _dio;

  DioNetwork({required Dio dio}) {
    _dio = dio;
    _dio.options.baseUrl = "http://18.194.52.136:8080";
    _dio.interceptors.add(NetworkInterceptor());
    _dio.options.validateStatus = (status) {
      return status != null && (status >= 200 && status < 300 || status == 500);
    };
  }

  Dio get dio => _dio;
}

class NetworkInterceptor extends Interceptor {
  final authLocalService = getIt.get<AuthLocalService>();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final token = authLocalService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = "Bearer $token";
      }
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to add token to request',
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response!.statusCode == 401) {
      if (authLocalService.containsKey(key: 'refresh_token')) {
        final authApiService = getIt.get<AuthApiService>();
        authApiService.refreshToken();
        final resolve = await authApiService.retry(err.requestOptions);
        return handler.resolve(resolve);
      } else {
        final authBloc = getIt.get<AuthBloc>();
        authBloc.add(LogoutAuthEvent());
      }
    }
    super.onError(err, handler);
  }
}

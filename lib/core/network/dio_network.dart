import 'package:carpet_delivery/logic/bloc/auth/auth_bloc.dart';
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
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    try {
      if (err.response?.statusCode == 401) {
        if (authLocalService.containsKey(key: 'refresh_token')) {
          final authApiService = getIt.get<AuthApiService>();

          // Refresh token
          final refreshResult = await authApiService.refreshToken();
          if (!refreshResult) {
            // Agar refresh token muvaffaqiyatsiz bo'lsa, foydalanuvchini chiqarib yuborish
            final authBloc = getIt.get<AuthBloc>();
            authBloc.add(LogoutAuthEvent());
            return handler.next(err);
          }

          // Yangi token bilan so'rovni qayta yuborish
          try {
            final options = err.requestOptions;
            final token = authLocalService.getAccessToken();
            options.headers['Authorization'] = "Bearer $token";

            final response = await getIt.get<Dio>().fetch(options);
            return handler.resolve(response);
          } catch (retryError) {
            return handler.next(DioException(
              requestOptions: err.requestOptions,
              error: 'Retry request failed: ${retryError.toString()}',
            ));
          }
        } else {
          // Refresh token yo'q bo'lsa, logout qilish
          final authBloc = getIt.get<AuthBloc>();
          authBloc.add(LogoutAuthEvent());
          return handler.next(err);
        }
      }
      return handler.next(err);
    } catch (e) {
      return handler.next(DioException(
        requestOptions: err.requestOptions,
        error: 'Error in interceptor: ${e.toString()}',
      ));
    }
  }
}

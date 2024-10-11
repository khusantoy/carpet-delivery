import 'dart:async';

import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/models/auth/auth_response.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient({required Dio dio}) {
    _dio = dio;
    _dio.options.baseUrl = "http://18.194.52.136:8081";
    _dio.interceptors.add(NetworkInterceptor());
    _dio.interceptors.add(RefreshTokenInterceptor(_dio));
  }

  Dio get dio => _dio;
}

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final authLocalService = getIt.get<AuthLocalService>();
      final token = authLocalService.getToken();
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
}

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  bool isRefreshing = false;
  final _queue = <Map<String, dynamic>>[];

  RefreshTokenInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRefreshToken(err)) {
      try {
        final requestOptions = err.requestOptions;

        // Navbatga qo'shish
        final completer = Completer<Response>();
        _queue.add({
          'completer': completer,
          'options': requestOptions,
        });

        // Agar refresh jarayoni bo'lmasa, refreshni boshlash
        if (!isRefreshing) {
          await _startRefreshToken();
        }

        // Natijani kutish
        final response = await completer.future;
        return handler.resolve(response);
      } catch (e) {
        return _handleAuthError(handler, err);
      }
    }
    return handler.next(err);
  }

  bool _shouldRefreshToken(DioException err) {
    return err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('refresh-token') &&
        !err.requestOptions.path.contains('login');
  }

  Future<void> _startRefreshToken() async {
    isRefreshing = true;
    try {
      final authLocalService = getIt.get<AuthLocalService>();
      final refreshToken = authLocalService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Refresh token not found',
        );
      }

      final response = await Dio().post(
        '${dio.options.baseUrl}/auth/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final authResponse = AuthResponse.fromMap(data);

        await authLocalService.saveToken(authResponse);
        await authLocalService.saveRefreshToken(authResponse);

        // Navbatdagi so'rovlarni qayta yuborish
        for (final item in _queue) {
          final options = item['options'] as RequestOptions;
          final completer = item['completer'] as Completer<Response>;

          try {
            final retryResponse = await _retry(options);
            completer.complete(retryResponse);
          } catch (e) {
            completer.completeError(e);
          }
        }
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Invalid response status code',
        );
      }
    } catch (e) {
      // Navbatdagi barcha so'rovlarga xato qaytarish
      for (final item in _queue) {
        final completer = item['completer'] as Completer<Response>;
        completer.completeError(e);
      }
      rethrow;
    } finally {
      _queue.clear();
      isRefreshing = false;
    }
  }

  void _handleAuthError(ErrorInterceptorHandler handler, DioException err) {
    try {
      final authLocalService = getIt.get<AuthLocalService>();
      authLocalService.clearTokens();
      // Bu yerda NavigationService orqali login ekraniga yo'naltirish kerak
    } catch (e) {
      print('Error clearing tokens: $e');
    }
    return handler.next(err);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return await dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

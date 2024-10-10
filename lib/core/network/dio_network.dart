import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/models/auth/auth_response.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:dio/dio.dart';

class DioNetwork {
  late final Dio _dio;

  DioNetwork({required Dio dio}) {
    _dio = dio;
    _dio.options.baseUrl = "http://18.194.52.136:8080";
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

  RefreshTokenInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final response = await _refreshToken();
        if (response != null) {
          return handler.resolve(await _retry(err.requestOptions));
        } else {
          // Refresh token response null bo'lsa
          _handleAuthError(handler, err);
        }
      } catch (e) {
        _handleAuthError(handler, err);
      }
    } else {
      return handler.next(err);
    }
  }

  void _handleAuthError(ErrorInterceptorHandler handler, DioException err) {
    try {
      final authLocalService = getIt.get<AuthLocalService>();
      authLocalService.clearTokens();
    } catch (e) {
      print('Error clearing tokens: $e');
    }
    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    try {
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
    } catch (e) {
      throw DioException(
        requestOptions: requestOptions,
        error: 'Failed to retry request',
      );
    }
  }

  Future<Response?> _refreshToken() async {
    if (isRefreshing) return null;

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

      final response = await dio.post(
        '/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final newToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newToken == null || newRefreshToken == null) {
          throw DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Invalid token response',
          );
        }

        final authResponse =
            AuthResponse(token: newToken, refreshToken: newRefreshToken);

        await authLocalService.saveToken(authResponse);
        await authLocalService.saveRefreshToken(authResponse);

        return response;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Invalid response status code',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      isRefreshing = false;
    }
  }
}

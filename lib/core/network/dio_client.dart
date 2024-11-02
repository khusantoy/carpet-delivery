import 'dart:async';
import 'dart:collection';

import 'package:carpet_delivery/logic/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/services/auth_api_service.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient({required Dio dio}) {
    _dio = dio;
    _dio.options.baseUrl = "http://18.194.52.136:8081";
    _dio.interceptors.add(NetworkInterceptor());
  }

  Dio get dio => _dio;
}

class NetworkInterceptor extends Interceptor {
  final authLocalService = getIt.get<AuthLocalService>();
  bool _isRefreshing = false;
  final Queue<Completer> _refreshTokenQueue = Queue();

  Future<void> _queueRequest() async {
    final completer = Completer();
    _refreshTokenQueue.add(completer);
    await completer.future;
  }

  void _resolveQueue() {
    for (var completer in _refreshTokenQueue) {
      completer.complete();
    }
    _refreshTokenQueue.clear();
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        if (_isRefreshing) {
          await _queueRequest();
          final response =
              await getIt.get<AuthApiService>().retry(err.requestOptions);
          handler.resolve(response);
          return;
        }

        _isRefreshing = true;

        if (authLocalService.containsKey(key: 'refresh_token')) {
          final authApiService = getIt.get<AuthApiService>();
          final isRefreshed = await authApiService.refreshToken();

          if (isRefreshed) {
            _resolveQueue();
            final response = await authApiService.retry(err.requestOptions);
            _isRefreshing = false;
            handler.resolve(response);
            return;
          }
        }

        _isRefreshing = false;
        final authBloc = getIt.get<AuthBloc>();
        authBloc.add(LogoutAuthEvent());
        handler.reject(err);
        return;
      } catch (e) {
        _isRefreshing = false;
        final authBloc = getIt.get<AuthBloc>();
        authBloc.add(LogoutAuthEvent());
        handler.reject(err);
        return;
      }
    }
    handler.reject(err);
  }

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
}

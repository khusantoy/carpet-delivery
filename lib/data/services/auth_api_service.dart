import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/dio_client.dart';
import 'package:carpet_delivery/data/models/auth/auth_response.dart';
import 'package:carpet_delivery/data/models/auth/login_request.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:dio/dio.dart';

class AuthApiService {
  final _dio = getIt.get<DioClient>().dio;

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post("/login", data: request.toMap());

      return AuthResponse.fromMap(response.data);
    } on DioException catch (e) {
      String errorMessage = '';

      if (e.response != null) {
        errorMessage =
            e.response?.data['message'] ?? 'An unknown error occurred';
        print("Login Service Dio Error: $errorMessage");
      } else {
        print("Login Service Dio Error: ${e.message}");
      }
      throw (errorMessage);
    } catch (e) {
      print("Login Service Error: $e");
      rethrow;
    }
  }

  Future<int?> refreshToken() async {
    final authLocalService = getIt.get<AuthLocalService>();
    final refreshToken = authLocalService.getRefreshToken();

    // Refresh token null bo'lishi mumkin
    if (refreshToken == null) {
      final authBloc = getIt.get<AuthBloc>();
      authBloc.add(LogoutAuthEvent());
      return null;
    }

    try {
      final response = await _dio.post(
        "/refresh-token",
        data: {
          "refresh_token": refreshToken,
        },
        // Timeout qo'shamiz
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Response data null bo'lishi mumkin
      if (response.data == null || response.data['access_token'] == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Invalid response format',
        );
      }

      if (response.statusCode == 200) {
        await authLocalService.saveAccessToken(
          AuthResponse(
            token: response.data['access_token'],
            refreshToken: refreshToken,
          ),
        );
        return response.statusCode;
      } else {
        // Status code 200 bo'lmasa
        final authBloc = getIt.get<AuthBloc>();
        authBloc.add(LogoutAuthEvent());
        return response.statusCode;
      }
    } on DioException catch (e) {
      // 401 holatini alohida handle qilamiz
      if (e.response?.statusCode == 401) {
        final authBloc = getIt.get<AuthBloc>();
        authBloc.add(LogoutAuthEvent());
        return e.response?.statusCode;
      }

      String errorMessage = e.response?.data?['message'] ??
          e.message ??
          'An unknown error occurred';

      throw errorMessage;
    } catch (e) {
      throw 'Failed to refresh token: $e';
    }
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    try {
      final options = Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        // Qo'shimcha muhim parametrlarni saqlaymiz
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        contentType: requestOptions.contentType,
        responseType: requestOptions.responseType,
        validateStatus: requestOptions.validateStatus,
      );

      return await _dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
    } catch (e) {
      throw DioException(
        requestOptions: requestOptions,
        error: 'Failed to retry request: $e',
      );
    }
  }
}

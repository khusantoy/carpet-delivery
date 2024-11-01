import 'package:carpet_delivery/logic/bloc/auth/auth_bloc.dart';
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

  Future<void> refreshToken() async {
    final authLocalService = getIt.get<AuthLocalService>();
    final refreshToken = authLocalService.getRefreshToken();

    try {
      final response = await _dio.post("/refresh-token", data: {
        "refresh_token": refreshToken,
      });

      if (response.statusCode == 200) {
        await authLocalService.saveAccessToken(AuthResponse(
          token: response.data['access_token'],
          refreshToken: refreshToken!,
        ));
      } else {
        final authBloc = getIt.get<AuthBloc>();
        authBloc.add(LogoutAuthEvent());
      }
    } on DioException catch (e) {
      String errorMessage = '';

      if (e.response != null) {
        errorMessage =
            e.response?.data['message'] ?? 'An unknown error occurred';
        print("Refresh token Dio Error: $errorMessage");
      } else {
        print("Refresh token Dio Error: ${e.message}");
      }
      throw (errorMessage);
    } catch (e) {
      print("Refresh token Error: $e");
      rethrow;
    }
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return await _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

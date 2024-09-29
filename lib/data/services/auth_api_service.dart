import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/dio_client.dart';
import 'package:carpet_delivery/data/models/auth/auth_response.dart';
import 'package:carpet_delivery/data/models/auth/login_request.dart';
import 'package:dio/dio.dart';

class AuthApiService {
  final _dio = getIt.get<DioClient>().dio;

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post("/login", data: request.toMap());
      return AuthResponse.fromMap(response.data);
    } on DioException catch (e) {
      print("Login Service Dio Error:$e");
      rethrow;
    } catch (e) {
      print("Login Service Error:$e");
      rethrow;
    }
  }

  
}

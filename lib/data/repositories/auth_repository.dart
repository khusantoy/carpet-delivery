import 'package:carpet_delivery/data/models/auth/auth_response.dart';
import 'package:carpet_delivery/data/models/auth/login_request.dart';
import 'package:carpet_delivery/data/services/auth_api_service.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final AuthLocalService authLocalService;

  AuthRepository({
    required this.authApiService,
    required this.authLocalService,
  });

  Future<void> login(LoginRequest request) async {
    final AuthResponse authResponse = await authApiService.login(request);
    await authLocalService.saveToken(authResponse);
  }

  Future<void> logout() async {
    await authLocalService.deleteToken();
  }
}

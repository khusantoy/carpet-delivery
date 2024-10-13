import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/models/auth/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalService {
  final token = "token";
  final refreshToken = "refresh_token";

  final preferance = getIt.get<SharedPreferences>();

  Future<void> saveAccessToken(AuthResponse auth) async {
    await preferance.setString(token, auth.token);
  }

  Future<void> saveRefreshToken(AuthResponse auth) async {
    await preferance.setString(refreshToken, auth.refreshToken);
  }

  String? getAccessToken() {
    return preferance.getString(token);
  }

  String? getRefreshToken() {
    return preferance.getString(refreshToken);
  }

  Future<void> deleteAccessToken() async {
    await preferance.remove(token);
  }

  Future<void> deleteRefreshToken() async {
    await preferance.remove(refreshToken);
  }
}

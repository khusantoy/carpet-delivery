import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/models/auth/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalService {
  final token = "token";
  final preferance = getIt.get<SharedPreferences>();

  Future<void> saveToken(AuthResponse auth) async {
    await preferance.setString(token, auth.token);
  }

  String? getToken() {
    return preferance.getString(token);
  }

  Future<void> deleteToken() async {
    await preferance.remove(token);
  }
}

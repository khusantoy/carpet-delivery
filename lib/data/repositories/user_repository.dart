import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/models/user/user.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:carpet_delivery/data/services/user_profile_api_service.dart';

class UserRepository {
  final UserProfileApiService userProfileApiService;

  UserRepository({required this.userProfileApiService});

  Future<User?> getUser() async {
    final prefs = getIt.get<AuthLocalService>();
    final id = prefs.getToken();
    return await userProfileApiService.getUserInfo(id);
  }
}

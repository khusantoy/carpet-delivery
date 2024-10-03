import 'package:carpet_delivery/data/models/user/user.dart';
import 'package:carpet_delivery/data/services/user_profile_api_service.dart';

class UserRepository {
  final UserProfileApiService userProfileApiService;

  UserRepository({required this.userProfileApiService});

  Future<User?> getUser() async {
    return await userProfileApiService.getUserInfo();
  }
}

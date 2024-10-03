import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/dio_client.dart';
import 'package:carpet_delivery/data/models/user/user.dart';
import 'package:dio/dio.dart';

class UserProfileApiService {
  final _dio = getIt.get<DioClient>().dio;

  Future<User?> getUserInfo() async {
    try {
      final response = await _dio.get("/users/profile",
          queryParameters: {'id': "41674b2b-ca73-4c4c-af2d-367cedcdfd27"});

      if (response.statusCode == 200) {
        return User.fromMap(response.data);
      } else {
        print('Failed to fetch user info: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print("UserProfileApiService Dio Error: $e");
      rethrow;
    } catch (e) {
      print("UserProfileApiService Error: $e");
      rethrow;
    }
  }
}

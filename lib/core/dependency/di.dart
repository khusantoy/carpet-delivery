import 'package:carpet_delivery/core/network/dio_client.dart';
import 'package:carpet_delivery/core/network/dio_network.dart';
import 'package:carpet_delivery/data/repositories/auth_repository.dart';
import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:carpet_delivery/data/repositories/user_repository.dart';
import 'package:carpet_delivery/data/services/auth_api_service.dart';
import 'package:carpet_delivery/data/services/auth_local_service.dart';
import 'package:carpet_delivery/data/services/order_service.dart';
import 'package:carpet_delivery/data/services/user_profile_api_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> dependencyInit() async {
  final preferance = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => preferance);
  getIt.registerLazySingleton(() => DioClient(dio: Dio()));
  getIt.registerLazySingleton(() => DioNetwork(dio: Dio()));

  // Services
  getIt.registerLazySingleton(() => AuthApiService());
  getIt.registerLazySingleton(() => AuthLocalService());
  getIt.registerLazySingleton(() => UserProfileApiService());
  getIt.registerLazySingleton(() => OrderService());

  // Repositories
  getIt.registerSingleton(
    AuthRepository(
      authApiService: getIt.get<AuthApiService>(),
      authLocalService: getIt.get<AuthLocalService>(),
    ),
  );
  getIt.registerSingleton(
    UserRepository(
      userProfileApiService: getIt.get<UserProfileApiService>(),
    ),
  );

  getIt.registerSingleton(
    OrderRepository(
      orderService: getIt.get<OrderService>(),
    ),
  );
}

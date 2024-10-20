import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MyInternetChecker {
  // Internet ulanishini tekshirish
  static Future<bool> hasInternetConnection() async {
    try {
      // Connectivity holatini tekshirish
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Internet mavjudligini tekshirish
      final isDeviceConnected = await InternetConnectionChecker().hasConnection;
      return isDeviceConnected;
    } catch (e) {
      return false;
    }
  }

  // Internet holatini kuzatish
  static Stream<InternetConnectionStatus> observeInternetConnection() {
    return InternetConnectionChecker().onStatusChange;
  }
}

import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/bloc/status/status_bloc.dart';
import 'package:carpet_delivery/bloc/user_profile/user_bloc.dart';
import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/my_internet_checker.dart';
import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:carpet_delivery/data/repositories/user_repository.dart';
import 'package:carpet_delivery/presentation/screens/auth/login_screen.dart';
import 'package:carpet_delivery/presentation/screens/main/main_screen.dart';
import 'package:carpet_delivery/presentation/screens/splash_screen/splash_screen.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInit();

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt.get<AuthBloc>(),
          ),
          BlocProvider(
            create: (context) => UserBloc(
              userRepository: getIt.get<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => OrderBloc(
              orderRepository: getIt.get<OrderRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => StatusBloc(
              orderRepository: getIt.get<OrderRepository>(),
            ),
          )
        ],
        child: ToastificationWrapper(
          child: MaterialApp(
            title: 'Yetkazmalar',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.customBlack,
                foregroundColor: AppColors.white,
              ),
            ),
            home: StreamBuilder<InternetConnectionStatus>(
              stream: MyInternetChecker.observeInternetConnection(),
              builder: (context, snapshot) {
                if (snapshot.data == InternetConnectionStatus.disconnected) {
                  return Scaffold(
                    backgroundColor: AppColors.customBlack,
                    body: SafeArea(
                      child: Center(
                        child: Lottie.asset("assets/cat.json"),
                      ),
                    ),
                  );
                } else {
                  return BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) {
                      return current is! ErrorAuthState &&
                          current is! LoadingAuthState;
                    },
                    builder: (context, state) {
                      if (state is InitialAuthState) {
                        return const SplashScreen();
                      }
                      if (state is UnauthorizedAuthState) {
                        return const LoginScreen();
                      }
                      if (state is AuthorizedAuthState) {
                        return const MainScreen();
                      }

                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

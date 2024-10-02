import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/data/repositories/auth_repository.dart';
import 'package:carpet_delivery/presentation/screens/delivery/deliveries_screen.dart';
import 'package:carpet_delivery/presentation/screens/login/login_screen.dart';
import 'package:carpet_delivery/presentation/screens/main/main_screen.dart';
import 'package:carpet_delivery/presentation/screens/splash_screen/splash_screen.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInit();

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
            create: (context) => AuthBloc(
              authRepository: getIt.get<AuthRepository>(),
            ),
          )
        ],
        child: MaterialApp(
            title: 'Yetkazib berish',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.white,
              ),
            ),
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                print("Salom $state");
                if (state is InitialAuthState) {
                  return const SplashScreen();
                }
                if (state is UnauthorizedAuthState) {
                  return const LoginScreen();
                }
                if (state is AuthorizedAuthState) {
                  return const MainScreen();
                }
                if (state is UnauthorizedAuthState) {
                  return const LoginScreen();
                }
                if (state is ErrorAuthState) {
                  return Scaffold(
                    body: Center(
                      child: Text(state.message),
                    ),
                  );
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            )),
      ),
    );
  }
}

import 'package:carpet_delivery/logic/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/logic/bloc/map/map_bloc.dart';
import 'package:carpet_delivery/logic/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/logic/bloc/status/status_bloc.dart';
import 'package:carpet_delivery/logic/bloc/user_profile/user_bloc.dart';
import 'package:carpet_delivery/core/dependency/di.dart';
import 'package:carpet_delivery/core/network/my_internet_checker.dart';
import 'package:carpet_delivery/logic/cubit/theme/theme_cubit.dart';
import 'package:carpet_delivery/data/repositories/order_repository.dart';
import 'package:carpet_delivery/data/repositories/user_repository.dart';
import 'package:carpet_delivery/presentation/screens/auth/login_screen.dart';
import 'package:carpet_delivery/presentation/screens/main/main_screen.dart';
import 'package:carpet_delivery/presentation/screens/splash_screen/splash_screen.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:carpet_delivery/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          ),
          BlocProvider(
            create: (context) => ThemeCubit(getIt.get<SharedPreferences>()),
          ),
          BlocProvider(
            create: (context) => MapBloc(
              getIt.get<OrderRepository>(),
            ),
          )
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return ToastificationWrapper(
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  systemNavigationBarColor: AppColors.customBlack,
                ),
                child: MaterialApp(
                  title: 'QulayYetkaz',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
                  home: StreamBuilder<InternetConnectionStatus>(
                    stream: MyInternetChecker.observeInternetConnection(),
                    builder: (context, snapshot) {
                      if (snapshot.data ==
                          InternetConnectionStatus.disconnected) {
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
            );
          },
        ),
      ),
    );
  }
}

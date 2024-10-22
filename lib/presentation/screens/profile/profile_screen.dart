import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/bloc/user_profile/user_bloc.dart';
import 'package:carpet_delivery/cubit/theme/theme_cubit.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String version = '';

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    return version;
  }

  @override
  void initState() {
    getVersion().then((value) {
      version = value;
    });
    super.initState();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(
            "Profildan chiqmoqchimisiz?",
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Bekor qilish",
                style: TextStyle(
                  color: AppColors.customBlack,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.customBlack,
              ),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutAuthEvent());
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ha",
                style: TextStyle(color: AppColors.white),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(context.watch<ThemeCubit>().isDark
                ? Icons.dark_mode
                : Icons.light_mode),
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        bloc: context.read<UserBloc>()..add(FetchUserProfileEvent()),
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is LoadedState) {
            final user = state.user;
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  color: AppColors.white,
                  child: ListTile(
                    leading: Container(
                      width: 64.w,
                      height: 64.h,
                      decoration: const BoxDecoration(
                        color: AppColors.avatarBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user.fullname[0],
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      user.fullname,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "@${user.username}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 6.h,
                  color: AppColors.scaffoldGrey,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 20.w,
                  ),
                  width: double.infinity,
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Telefon raqam",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        user.phoneNumber,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 6.h,
                  color: AppColors.scaffoldGrey,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 20.w,
                  ),
                  width: double.infinity,
                  color: AppColors.white,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.customBlack,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _logout();
                      },
                      child: const Text("Chiqish"),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "Versiya: $version",
                  style: const TextStyle(
                    color: AppColors.locationColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

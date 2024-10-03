import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      backgroundColor: AppColors.scaffoldGrey,
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 8.sp,
          ),
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
                    "SI",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              title: Text(
                "Shakhzod Ismoilov",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "@shakhzod.ux",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
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
                  "+998 99 123 45 67",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
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
          )
        ],
      ),
    );
  }
}

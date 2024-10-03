import 'package:carpet_delivery/bloc/user_profile/user_bloc.dart';
import 'package:carpet_delivery/main.dart';
import 'package:carpet_delivery/presentation/screens/delivery/deliveries_screen.dart';
import 'package:carpet_delivery/presentation/screens/profile/profile_screen.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          DeliveriesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60.h,
        child: BottomNavigationBar(
          backgroundColor: AppColors.customBlack,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.bottomNavigationLabelColor,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                "assets/icons/shipping_active.svg",
                width: 24.w,
                height: 24.h,
              ),
              icon: SvgPicture.asset(
                "assets/icons/shipping.svg",
                width: 24.w,
                height: 24.h,
              ),
              label: "Yetkazmalar",
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                "assets/icons/person_active.svg",
                width: 24.w,
                height: 24.h,
              ),
              icon: SvgPicture.asset(
                "assets/icons/person.svg",
                width: 24.w,
                height: 24.h,
              ),
              label: "Profil",
            )
          ],
        ),
      ),
    );
  }
}

import 'package:carpet_delivery/presentation/screens/delivery/deliveries_screen.dart';
import 'package:carpet_delivery/presentation/screens/profile/profile_screen.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
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
        height: 55.h,
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
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.local_shipping_rounded,
                color: Colors.white,
              ),
              icon: Icon(Icons.local_shipping_rounded),
              label: "Yetkazmalar",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.person,
              ),
              label: "Profil",
            )
          ],
        ),
      ),
    );
  }
}

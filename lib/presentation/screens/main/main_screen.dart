import 'package:carpet_delivery/presentation/screens/delivery/deliveries_screen.dart';
import 'package:carpet_delivery/presentation/screens/map/map_screen.dart';
import 'package:carpet_delivery/presentation/screens/profile/profile_screen.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.customBlack,
      ),
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: const [
            DeliveriesScreen(),
            MapScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                    color: Colors.white); // Selected label color
              }
              return const TextStyle(
                  color: Colors.grey); // Unselected label color
            }),
          ),
          child: NavigationBar(
            backgroundColor: AppColors.customBlack,
            selectedIndex: currentIndex,
            indicatorColor: AppColors.white,
            shadowColor: Colors.red,
            onDestinationSelected: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.local_shipping_rounded),
                icon: Icon(
                  Icons.local_shipping_rounded,
                  color: Colors.grey,
                ),
                label: 'Yetkazma',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.map),
                icon: Icon(
                  Icons.map,
                  color: Colors.grey,
                ),
                label: 'Xarita',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person),
                icon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

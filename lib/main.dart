import 'package:carpet_delivery/presentation/screens/delivery/deliveries_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Yetkazib berish',
        debugShowCheckedModeBanner: false,
        home: DeliveriesScreen(),
      ),
    );
  }
}

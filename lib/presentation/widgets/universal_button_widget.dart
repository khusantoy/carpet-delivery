import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniversalbuttonWidget extends StatelessWidget {
  final Function() function;
  final String text;

  const UniversalbuttonWidget(
      {super.key, required this.function, required this.text});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        height: 56.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: AppColors.customBlack,
        ),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 16.sp,
              letterSpacing: 3.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

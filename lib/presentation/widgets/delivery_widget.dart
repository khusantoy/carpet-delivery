import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductInfoWidget extends StatelessWidget {
  final String status;
  final String fullName;
  final String phoneNumber;

  const ProductInfoWidget({
    super.key,
    required this.status,
    required this.fullName,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    print(status);
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10).w,
                      color: status == 'RECEIVED'
                          ? AppColors.deliveredColorAccent
                          : status == 'PREPARING'
                              ? AppColors.deliveringColorAccent
                              : AppColors.readyColorAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: SvgPicture.asset(
                        status == 'RECEIVED'
                            ? "assets/icons/green_package_icon.svg"
                            : status == 'PREPARING'
                                ? "assets/icons/orange_package_icon.svg"
                                : "assets/icons/red_package_icon.svg",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: const Color(0xFF21252C),
                        ),
                      ),
                      Text(
                        fullName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.locationColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                ],
              ),
              PopupMenuButton(
                iconColor: const Color(0xFF76889A),
                color: AppColors.white,
                onSelected: (value) {},
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.map,
                            color: AppColors.yandexYellow,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          const Text("Xaritada ko'rish")
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.check_mark_circled,
                            color: AppColors.deliveredColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          const Text("Yetkazilgan")
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.paperplane,
                            color: AppColors.deliveringColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          const Text("Yetkazilyapti")
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.xmark_circle,
                            color: AppColors.readyColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          const Text("Yetkazilmagan")
                        ],
                      ),
                    )
                  ];
                },
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10).w,
                  color: const Color.fromARGB(255, 238, 244, 255),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0).w,
                  child: const Center(
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 96.w,
                child: Text(
                  "Chilonzor Tumani, 9-mavze, 2-dom, 1-padez, 8-xonadon",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.locationColor,
                  ),
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 56.w,
              ),
              Text(
                "Holati:",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF76889A),
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: status == 'RECEIVED'
                      ? AppColors.deliveredColorAccent
                      : status == 'PREPARING'
                          ? AppColors.deliveringColorAccent
                          : AppColors.readyColorAccent,
                  borderRadius: BorderRadius.circular(8).r,
                ),
                child: Text(
                  status == 'RECEIVED'
                      ? "Yetkazilgan"
                      : status == 'PREPARING'
                          ? 'Yetkazilyapti'
                          : 'Yetkazilmagan',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: status == 'RECEIVED'
                        ? AppColors.deliveredColor
                        : status == 'PREPARING'
                            ? AppColors.deliveringColor
                            : AppColors.readyColor,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductInfoWidget extends StatelessWidget {
  final String status;

  const ProductInfoWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0).w,
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
                      color: status == 'delivered'
                          ? AppColors.deliveredColorAccent
                          : status == 'delivering'
                              ? AppColors.deliveringColorAccent
                              : AppColors.readyColorAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: SvgPicture.asset(
                        status == 'delivered'
                            ? "assets/icons/green_package_icon.svg"
                            : status == 'delivering'
                                ? "assets/icons/orange_package_icon.svg"
                                : "assets/icons/red_package_icon.svg",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    "#5R9G87R",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: const Color(0xFF21252C),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Container(
                    width: 4.w,
                    height: 4.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD2D6DB),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "14 may 2024",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFFBABFC5),
                    ),
                  ),
                ],
              ),
              PopupMenuButton(
                iconColor: const Color(0xFF76889A),
                color: AppColors.white,
                onSelected: (value) {},
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.map,
                          color: AppColors.yandexYellow,
                        ),
                        title: Text("Yandex Map orqali ochish"),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.check_mark_circled,
                          color: AppColors.deliveredColor,
                        ),
                        title: Text("Yetkazilgan qilib belgilash"),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.paperplane,
                          color: AppColors.deliveringColor,
                        ),
                        title: Text("Yetkazilyapti qilib belgilash"),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.xmark_circle,
                          color: AppColors.readyColor,
                        ),
                        title: Text("Yetkazilmagan qilib belgilash"),
                      ),
                    )
                  ];
                },
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 56.w,
              ),
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                "Manzil",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFBABFC5),
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 72.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 122.w,
                child: Text(
                  "Chilonzor Tumani, 9-mavze, 2-dom, 1-padez, 8-xonadon",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF76889A),
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
                  color: status == 'delivered'
                      ? AppColors.deliveredColorAccent
                      : status == 'delivering'
                          ? AppColors.deliveringColorAccent
                          : AppColors.readyColorAccent,
                  borderRadius: BorderRadius.circular(8).r,
                ),
                child: Text(
                  status == 'delivered'
                      ? "Yetkazilgan"
                      : status == 'delivering'
                          ? 'Yetkazilyapti'
                          : 'Yetkazilmagan',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: status == 'delivered'
                        ? AppColors.deliveredColor
                        : status == 'delivering'
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

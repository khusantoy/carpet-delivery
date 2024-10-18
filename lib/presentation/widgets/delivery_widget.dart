import 'package:carpet_delivery/bloc/status/status_bloc.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductInfoWidget extends StatelessWidget {
  final String id;
  final String status;
  final String fullName;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String address;
  final String url;

  const ProductInfoWidget({
    super.key,
    required this.id,
    required this.status,
    required this.fullName,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
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
                      color: status == 'DELIVERED'
                          ? AppColors.deliveredColorAccent
                          : status == 'DELIVERING'
                              ? AppColors.deliveringColorAccent
                              : AppColors.readyColorAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: SvgPicture.asset(
                        status == 'DELIVERED'
                            ? "assets/icons/green_package_icon.svg"
                            : status == 'DELIVERING'
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
                      onTap: () async {
                        final yandexUrl = Uri.parse(
                            'yandexmaps://maps.yandex.ru/?'
                            'pt=$latitude,$longitude' // nuqta koordinatalari
                            '&z=14' // zoom darajasi (0-21)
                            '&text=${Uri.encodeComponent(address)}' // marker matni
                            );

                        if (await canLaunchUrl(yandexUrl)) {
                          await launchUrl(yandexUrl);
                        } else {
                          toastification.show(
                            context: context,
                            title: const Text("Yandex Map topilmadi"),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                            showProgressBar: false,
                            closeButtonShowType: CloseButtonShowType.none,
                          );
                        }
                      },
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
                      onTap: () {
                        context.read<StatusBloc>().add(ChangeStatusEvent(
                            orderId: id, status: "DELIVERED"));
                      },
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
                      onTap: () {
                        context.read<StatusBloc>().add(ChangeStatusEvent(
                            orderId: id, status: "DELIVERING"));
                      },
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
                      onTap: () {
                        context.read<StatusBloc>().add(
                            ChangeStatusEvent(orderId: id, status: "READY"));
                      },
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
                  color: status == 'DELIVERED'
                      ? AppColors.deliveredColorAccent
                      : status == 'DELIVERING'
                          ? AppColors.deliveringColorAccent
                          : AppColors.readyColorAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0).w,
                  child: Center(
                    child: Icon(
                      Icons.location_pin,
                      color: status == "DELIVERED"
                          ? AppColors.deliveredColor
                          : status == 'DELIVERING'
                              ? AppColors.deliveringColor
                              : AppColors.readyColor,
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
                  address,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.locationColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
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
                  color: status == 'DELIVERED'
                      ? AppColors.deliveredColorAccent
                      : status == 'DELIVERING'
                          ? AppColors.deliveringColorAccent
                          : AppColors.readyColorAccent,
                  borderRadius: BorderRadius.circular(8).r,
                ),
                child: Text(
                  status == 'DELIVERED'
                      ? "Yetkazilgan"
                      : status == 'DELIVERING'
                          ? 'Yetkazilyapti'
                          : 'Yetkazilmagan',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: status == 'DELIVERED'
                        ? AppColors.deliveredColor
                        : status == 'DELIVERING'
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

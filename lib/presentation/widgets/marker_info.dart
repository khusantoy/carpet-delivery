import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkerInfo extends StatefulWidget {
  final Order order;
  final double distance;
  final int duration;
  const MarkerInfo({
    super.key,
    required this.order,
    required this.distance,
    required this.duration,
  });

  @override
  State<MarkerInfo> createState() => _MarkerInfoState();
}

class _MarkerInfoState extends State<MarkerInfo> {
  Future<void> _openYandexMap() async {
    final yandexUrl = Uri.parse('yandexmaps://maps.yandex.ru/?'
        'pt=${widget.order.client.latitude},${widget.order.client.longitude}'
        '&z=14'
        '&text=${Uri.encodeComponent(widget.order.address)}');

    if (await canLaunchUrl(yandexUrl)) {
      await launchUrl(yandexUrl);
    } else {
      if (!mounted) return;

      toastification.show(
        context: context,
        title: const Text("Yandex Map topilmadi"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.customGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(widget.order.client.fullName),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.customGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(widget.order.client.phoneNumber),
              trailing: IconButton.outlined(
                onPressed: () {
                  launchUrl(
                      Uri.parse('tel:${widget.order.client.phoneNumber}'));
                },
                icon: const Icon(
                  Icons.phone,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.customGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(widget.order.address),
              trailing: IconButton.outlined(
                onPressed: _openYandexMap,
                icon: const Icon(
                  Icons.navigation_rounded,
                  color: AppColors.yandexYellow,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.customGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.near_me),
              title: Text(
                '~ ${widget.distance.toStringAsFixed(2)} km',
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.customGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.timer),
              title: Text("${widget.duration} daqiqa"),
            ),
          ),
        ],
      ),
    );
  }
}

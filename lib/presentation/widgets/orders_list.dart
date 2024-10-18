import 'package:carpet_delivery/data/models/order/order.dart';
import 'package:carpet_delivery/presentation/widgets/delivery_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersList extends StatelessWidget {
  final List<Order> orders;
  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 5.h,
        );
      },
      itemBuilder: (context, index) {
        final order = orders[index];

        return ProductInfoWidget(
          id: order.id,
          status: order.status,
          fullName: order.client.fullName,
          phoneNumber: order.client.phoneNumber,
          latitude: order.client.latitude,
          longitude: order.client.longitude,
          address: order.address,
          url: order.url,
        );
      },
    );
  }
}

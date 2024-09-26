import 'package:carpet_delivery/presentation/widgets/product_info_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldGrey,
      appBar: AppBar(
        title: const Text("Yetkazib berish"),
      ),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 8,
          );
        },
        itemBuilder: (context, index) {
          String status = 'delivered';

          if (index.isOdd) {
            status = 'delivering';
          } else if (index % 5 == 0) {
            status = 'ready';
          }

          return ProductInfoWidget(
            status: status,
          );
        },
      ),
    );
  }
}

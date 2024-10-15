import 'package:carpet_delivery/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/presentation/widgets/delivery_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

enum FilterItem { all, pending, progress, completed }

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  FilterItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldGrey,
      appBar: AppBar(
        title: Badge.count(
          count: 10,
          alignment: const Alignment(1.4, -1),
          child: const Text("Barchasi"),
        ),
        actions: [
          PopupMenuButton<FilterItem>(
            icon: const Icon(Icons.filter_alt),
            color: AppColors.white,
            initialValue: selectedItem,
            onSelected: (FilterItem item) {
              setState(() {
                selectedItem = item;
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    context.read<OrderBloc>().add(GetAllOrdersEvent());
                  },
                  value: FilterItem.all,
                  child: const Text("Barchasi"),
                ),
                PopupMenuItem(
                  onTap: () {
                    context.read<OrderBloc>().add(GetReadyOrdersEvent());
                  },
                  value: FilterItem.pending,
                  child: const Text("Yetkazilmagan"),
                ),
                PopupMenuItem(
                  onTap: () {
                    context.read<OrderBloc>().add(GetDeliveringOrdersEvent());
                  },
                  value: FilterItem.progress,
                  child: const Text("Yetkazilmoqda"),
                ),
                PopupMenuItem(
                  onTap: () {
                    context.read<OrderBloc>().add(GetDeliveredOrdersEvent());
                  },
                  value: FilterItem.completed,
                  child: const Text("Yetkazilgan"),
                )
              ];
            },
          )
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is LoadingOrderState) {
            return Center(
              child: Lottie.asset('assets/lottie.json'),
            );
          }

          if (state is ErrorOrderState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is LoadedOrderState) {
            final orders = state.orders;

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
                  status: order.status,
                  fullName: order.client.fullName,
                  phoneNumber: order.client.phoneNumber,
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

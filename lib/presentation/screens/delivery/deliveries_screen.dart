import 'package:carpet_delivery/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/presentation/widgets/delivery_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldGrey,
      appBar: AppBar(
        title: const Text("Yetkazib berish"),
        actions: [
          DropdownMenu(
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.),
            ),
            onSelected: (String? value) {},
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: "all", label: "Barchasi"),
              DropdownMenuEntry(value: "pending", label: "Kutilmoqda"),
              DropdownMenuEntry(value: "progress", label: "Jarayonda"),
              DropdownMenuEntry(value: "completed", label: "Tugallangan"),
            ],
          )
        ],
      ),
      body: BlocBuilder(
        bloc: context.read<OrderBloc>()..add(GetOrderEvent(page: 1, limit: 10)),
        builder: (context, state) {
          if (state is LoadingOrderState) {
            return const Center(
              child: CircularProgressIndicator(),
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
              itemCount: 10,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 8,
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

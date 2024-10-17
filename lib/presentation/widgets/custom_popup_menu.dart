import 'package:carpet_delivery/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FilterItem { all, pending, progress, completed }

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu({super.key});

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  FilterItem? selectedItem = FilterItem.all;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FilterItem>(
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
    );
  }
}

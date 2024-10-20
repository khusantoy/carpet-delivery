import 'package:carpet_delivery/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/bloc/status/status_bloc.dart';
import 'package:carpet_delivery/presentation/widgets/custom_popup_menu.dart';
import 'package:carpet_delivery/presentation/widgets/delivery_widget.dart';
import 'package:carpet_delivery/presentation/widgets/loading_order_shimmer.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  String title = "Barchasi";
  double x = 1.4;
  double y = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldGrey,
      appBar: AppBar(
        title: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            int count = 0;
            if (state is LoadedOrderState) {
              count = state.count;
              title = state.title;
              x = state.x;
              y = state.y;
            } else if (state is LoadingOrderState) {
              title = state.lastTitle ?? title;
              x = state.x ?? x;
              y = state.y ?? y;
            }

            return Badge.count(
              count: count,
              alignment: Alignment(x, y),
              child: Text(title),
            );
          },
        ),
        actions: const [CustomPopupMenu()],
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.customBlack,
        color: AppColors.white,
        onRefresh: () {
          context
              .read<OrderBloc>()
              .add(RefreshOrdersEvent(lastTitle: title, x: x, y: y));
          return Future.delayed(const Duration(milliseconds: 1500));
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          bloc: context.read<OrderBloc>()..add(GetOrdersEvent()),
          builder: (context, state) {
            if (state is LoadingOrderState) {
              return const LoadingOrderShimmer();
            }

            if (state is ErrorOrderState) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is LoadedOrderState) {
              final orders = state.filteredOrders;

              return BlocConsumer<StatusBloc, StatusState>(
                listener: (context, state) {
                  if (state is LoadedStatusState) {
                    if (state.isSuccess) {
                      toastification.show(
                        context: context,
                        title: const Text("Status o'zgartirildi"),
                        type: ToastificationType.success,
                        autoCloseDuration: const Duration(seconds: 3),
                        showProgressBar: false,
                        closeButtonShowType: CloseButtonShowType.none,
                      );

                      context.read<OrderBloc>().add(ChangeStatusOrdersEvent(
                          status: state.status, orderId: state.orderId));
                    } else {
                      toastification.show(
                        context: context,
                        title: const Text("Nimadir xato"),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                        showProgressBar: false,
                        closeButtonShowType: CloseButtonShowType.none,
                      );
                    }
                  }
                },
                builder: (context, state) {
                  return orders.isEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom -
                              kToolbarHeight,
                          color: Colors.white,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/empty.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : ListView.separated(
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
                            );
                          },
                        );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

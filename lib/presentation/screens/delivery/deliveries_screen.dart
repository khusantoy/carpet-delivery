import 'package:carpet_delivery/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/presentation/widgets/custom_popup_menu.dart';
import 'package:carpet_delivery/presentation/widgets/delivery_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  String title = "Barchasi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldGrey,
      appBar: AppBar(
        title: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            int count = 0;
            String title = "Barchasi";
            double x = 1.4;
            double y = -1;
            if (state is LoadedOrderState) {
              count = state.count;
              title = state.title;
              x = state.x;
              y = state.y;
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
      body: BlocBuilder<OrderBloc, OrderState>(
        bloc: context.read<OrderBloc>()..add(GetOrdersEvent()),
        builder: (context, state) {
          if (state is LoadingOrderState) {
            return ListView.separated(
              itemCount: 4,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 5.h,
                );
              },
              itemBuilder: (context, index) {
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
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10).w,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              SizedBox(
                                width: 150.w,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 130.w,
                                        height: 14.sp,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 150.w,
                                        height: 14.sp,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10).w,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 96.w,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        96.w * 0.9,
                                    height: 14.sp,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        96.w * 0.7,
                                    height: 14.sp,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ],
                              ),
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
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 50,
                              height: 14.sp,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 8.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8).r,
                              ),
                              child: Text(
                                "Yetkazilmagan",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }

          if (state is ErrorOrderState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is LoadedOrderState) {
            final orders = state.filteredOrders;

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
                  latitude: order.client.latitude,
                  longitude: order.client.longitude,
                  address: order.address,
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

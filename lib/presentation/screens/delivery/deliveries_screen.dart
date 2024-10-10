import 'package:carpet_delivery/bloc/order/order_bloc.dart';
import 'package:carpet_delivery/presentation/widgets/delivery_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldGrey,
        appBar: AppBar(
          title: const Text("Yetkazib berish"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.assignment_turned_in),
              ),
            )
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.customBlack,
            indicatorWeight: 4,
            labelColor: AppColors.customBlack,
            unselectedLabelColor: AppColors.locationColor,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(
                child: Badge(
                  offset: Offset(18, -8),
                  label: Text("10"),
                  child: Text("Barchasi"),
                ),
              ),
              Tab(
                child: Badge(
                  offset: Offset(16, -8),
                  label: Text("10"),
                  child: Text("Yetkazilmagan"),
                ),
              ),
              Tab(
                child: Badge(
                  offset: Offset(16, -8),
                  label: Text("999"),
                  child: Text("Yetkazilyapti"),
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder(
          bloc: context.read<OrderBloc>()
            ..add(GetOrderEvent(page: 1, limit: 10)),
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

              return TabBarView(
                children: [
                  ListView.separated(
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
                  ),
                  ListView.separated(
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
                  ),
                  ListView.separated(
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
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

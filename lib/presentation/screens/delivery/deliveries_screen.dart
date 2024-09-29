import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/presentation/widgets/product_info_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldGrey,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutAuthEvent());
                },
                icon: const Icon(Icons.logout))
          ],
          title: const Text("Yetkazib berish"),
          bottom: const TabBar(
            indicatorColor: AppColors.customBlack,
            indicatorWeight: 4,
            labelColor: AppColors.customBlack,
            unselectedLabelColor: AppColors.locationColor,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                text: "Barchasi",
              ),
              Tab(
                text: "Yetkazilmagan",
              ),
              Tab(
                text: "Yetkazilyapti",
              ),
              Tab(
                text: "Yetkazilgan",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
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
            ListView.separated(
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
            ListView.separated(
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
            ListView.separated(
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
          ],
        ),
      ),
    );
  }
}

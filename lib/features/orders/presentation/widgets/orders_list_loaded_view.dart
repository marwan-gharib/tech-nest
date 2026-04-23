import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/presentation/widgets/empty_orders_widget.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_list_item.dart';

class OrdersListLoadedView extends StatelessWidget {
  final List<OrderEntity> orders;

  const OrdersListLoadedView({required this.orders, super.key});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const EmptyOrdersWidget();
    }

    return RefreshIndicator(
      onRefresh: () => context.read<OrdersListCubit>().fetchOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderListItem(order: orders[index]);
        },
      ),
    );
  }
}

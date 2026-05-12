import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/animations/animate_once_wrapper.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/no_results_found_view.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_list_item.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrdersListLoadedView extends StatelessWidget {
  final List<OrderEntity> orders;

  const OrdersListLoadedView({required this.orders, super.key});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return NoResultsFoundView(
        title: context.t.orders.emptyStateTitle,
        message: context.t.orders.emptyStateMessage,
        icon: Icons.shopping_bag_outlined,
        onRefresh: () => context.read<OrdersListCubit>().fetchOrders(),
      );
    }

    return RepaintBoundary(
      child: RefreshIndicator(
        onRefresh: () => context.read<OrdersListCubit>().fetchOrders(),
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return AnimateOnceWrapper(
              namespace: 'orders_list',
              id: 'order_item_${order.id}',
              child: OrderListItem(order: order),
              animationBuilder: (context, child) => FadeInSlide(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: index * 50),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

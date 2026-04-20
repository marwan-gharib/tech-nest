import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_state.dart';
import 'package:tech_nest/features/orders/presentation/widgets/empty_orders_widget.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_list_item.dart';
import 'package:tech_nest/features/orders/presentation/widgets/orders_skeleton_list.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.orders.title),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<OrdersListCubit, OrdersListState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is OrdersListLoading || state is OrdersListInitial) {
            return const OrdersSkeletonList();
          }

          if (state is OrdersListFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.failure.message),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<OrdersListCubit>().fetchOrders(),
                    child: Text(context.t.common.retry),
                  ),
                ],
              ),
            );
          }

          if (state is OrdersListLoaded) {
            if (state.orders.isEmpty) {
              return const EmptyOrdersWidget();
            }

            return RefreshIndicator(
              onRefresh: () => context.read<OrdersListCubit>().fetchOrders(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return OrderListItem(order: state.orders[index]);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

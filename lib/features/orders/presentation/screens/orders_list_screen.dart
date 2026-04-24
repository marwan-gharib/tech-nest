import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_state.dart';
import 'package:tech_nest/core/shared/presentation/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/orders/presentation/widgets/orders_list_loaded_view.dart';
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
          return switch (state) {
            OrdersListLoading() ||
            OrdersListInitial() => const OrdersSkeletonList(),
            OrdersListFailed(failure: final failure) => RemoteDataFailureView(
              failure: failure,
              onRetry: () => context.read<OrdersListCubit>().fetchOrders(),
            ),
            OrdersListLoaded(orders: final orders) => OrdersListLoadedView(
              orders: orders,
            ),
          };
        },
      ),
    );
  }
}

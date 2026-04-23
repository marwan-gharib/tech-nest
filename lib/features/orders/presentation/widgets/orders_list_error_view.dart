import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/shared/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrdersListErrorView extends StatelessWidget {
  final String message;

  const OrdersListErrorView({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () => context.read<OrdersListCubit>().fetchOrders(),
            child: Text(context.t.common.retry),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class CancelOrderDialog extends StatelessWidget {
  final int orderId;

  const CancelOrderDialog({
    required this.orderId,
    super.key,
  });

  static Future<void> show(BuildContext context, int orderId) {
    return showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<OrderDetailsCubit>(),
        child: CancelOrderDialog(orderId: orderId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.t.orders.cancelOrder),
      content: Text(context.t.orders.cancelConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            context.t.orders.cancelNo,
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.error,
            foregroundColor: context.colorScheme.onError,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<OrderDetailsCubit>().cancelOrder(orderId);
          },
          child: Text(context.t.orders.cancelYes),
        ),

      ],
    );
  }
}


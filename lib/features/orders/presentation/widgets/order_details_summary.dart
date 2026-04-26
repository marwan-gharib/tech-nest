import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/presentation/widgets/cancel_order_dialog.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrderDetailsSummary extends StatelessWidget {
  final OrderDetailsEntity order;
  final bool isCancelling;

  const OrderDetailsSummary({
    required this.order,
    required this.isCancelling,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.t.cart.total,
              style: context.titleLarge,
            ),
            Text(
              '\$${order.totalPrice.toStringAsFixed(2)}',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        if (order.status == OrderStatus.pending)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.error.withValues(alpha: 0.1),
                foregroundColor: context.colors.error,
                elevation: 0,
              ),
              onPressed: isCancelling
                  ? null
                  : () => CancelOrderDialog.show(context, order.id),
              child: isCancelling
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.error,
                      ),
                    )
                  : Text(context.t.orders.cancelOrder),
            ),
          ),
      ],
    );
  }
}


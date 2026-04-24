import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrderDetailsAddresses extends StatelessWidget {
  final OrderDetailsEntity order;

  const OrderDetailsAddresses({
    required this.order,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.orders.shippingAddress,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(order.shippingAddress),
        const SizedBox(height: AppSpacing.md),
        Text(
          context.t.orders.billingAddress,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(order.billingAddress),
      ],
    );
  }
}

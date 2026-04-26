import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case OrderStatus.pending:
        color = context.colors.warning;
        label = context.t.orders.status.pending;
        break;
      case OrderStatus.confirmed:
        color = context.colors.info;
        label = context.t.orders.status.confirmed;
        break;
      case OrderStatus.shipped:
        color = context.colorScheme.secondary;
        label = context.t.orders.status.shipped;
        break;
      case OrderStatus.delivered:
        color = context.colors.success;
        label = context.t.orders.status.delivered;
        break;
      case OrderStatus.cancelled:
        color = context.colors.error;
        label = context.t.orders.status.cancelled;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: context.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


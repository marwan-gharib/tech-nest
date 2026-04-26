import 'package:flutter/material.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_status_chip.dart';

class OrderDetailsHeader extends StatelessWidget {
  final OrderDetailsEntity order;

  const OrderDetailsHeader({
    required this.order,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '#${order.id}',
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        OrderStatusChip(status: order.status),
      ],
    );
  }
}


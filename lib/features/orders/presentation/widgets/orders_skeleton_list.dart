import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrdersSkeletonList extends StatelessWidget {
  const OrdersSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(AppSpacing.md),
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            color: context.colors.card,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.t.orders.details, style: context.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        width: 80,
                        height: 24,
                        color: context.colors.shimmerBase,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(context.t.orders.date(date: '12/12/2026'), style: context.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.t.cart.total, style: context.bodyMedium),
                      Text('\$150.00', style: context.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



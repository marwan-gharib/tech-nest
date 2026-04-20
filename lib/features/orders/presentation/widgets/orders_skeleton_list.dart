import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

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
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order #1234', style: TextStyle(fontSize: 16)),
                      Container(width: 80, height: 24, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text('Ordered on: 12/12/2026'),
                  const SizedBox(height: AppSpacing.md),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Total'), Text('\$150.00')],
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

import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(borderRadius: AppRadius.cardLg),
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: AppRadius.cardLg,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.3,
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

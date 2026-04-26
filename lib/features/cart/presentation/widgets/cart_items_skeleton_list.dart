import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class CartItemsSkeletonList extends StatelessWidget {
  const CartItemsSkeletonList({super.key});

  static const int _placeholderCount = 5;
  static const double _rowHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _placeholderCount,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Skeletonizer(
            child: Container(
              height: _rowHeight,
              decoration: BoxDecoration(
                color: context.colors.shimmerBase,
                borderRadius: AppRadius.cardLg,
              ),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: AppSpacing.xxl + AppSpacing.lg * 2,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colors.shimmerHighlight.withValues(alpha: 0.5),
                      borderRadius: AppRadius.cardMd,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm + 1),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: AppSpacing.md,
                          width: AppSpacing.xxl * 2,
                          color: context.colors.shimmerHighlight.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          height: AppSpacing.sm,
                          width: AppSpacing.xl,
                          color: context.colors.shimmerHighlight.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


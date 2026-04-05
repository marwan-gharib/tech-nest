import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class SkeletonCard extends StatelessWidget {
  static const double _cardHeight = 200.0;

  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: colorScheme.surfaceContainerHighest,
          highlightColor: colorScheme.surface,
          duration: const Duration(milliseconds: 1500),
        ),
      ),
      child: Skeletonizer(
        enabled: true,
        child: Container(
          height: _cardHeight,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadius.cardLg,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_skeletonCardImage(), _skeletonCardFooter()],
          ),
        ),
      ),
    );
  }

  Widget _skeletonCardImage() {
    return const Expanded(
      child: Bone(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
    );
  }

  Widget _skeletonCardFooter() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Bone(width: double.infinity, height: 14),
                SizedBox(height: AppSpacing.xs),
                Bone(width: 60, height: 12),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Bone.circle(size: 32),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class SkeletonCard extends StatelessWidget {
  static const double _cardHeight = 200.0;

  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: context.colors.shimmerBase,
          highlightColor: context.colors.shimmerHighlight,
          duration: const Duration(milliseconds: 1500),
        ),
      ),
      child: Skeletonizer(
        enabled: true,
        child: Container(
          height: _cardHeight,
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: AppRadius.cardLg,
            boxShadow: [
              BoxShadow(
                color: context.colors.textPrimary.withValues(alpha: 0.05),
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


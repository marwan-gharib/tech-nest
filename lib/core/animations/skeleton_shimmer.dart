import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/app_animations.dart';
import 'package:tech_nest/core/animations/shimmer_effect.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class SkeletonShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonShimmer({
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final baseColor = colors.shimmerBase;
    final highlightColor = colors.shimmerHighlight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: baseColor),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: -1.0, end: 2.0),
          duration: AppAnimations.extraSlow,
          builder: (context, value, child) {
            return ShimmerEffect(
              value: value,
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: child ?? const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}


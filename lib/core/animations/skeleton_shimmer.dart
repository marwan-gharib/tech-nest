import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/app_animations.dart';
import 'package:tech_nest/core/animations/shimmer_effect.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: baseColor),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: -1.0, end: 2.0),
          duration: AppAnimations.extraSlow,
          onEnd:
              () {}, // Handled by repeating logic below if we were using a controller
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

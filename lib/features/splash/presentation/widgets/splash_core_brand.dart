import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class SplashCoreBrand extends StatelessWidget {
  final AnimationController controller;

  const SplashCoreBrand({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final coreScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 70),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(controller);

    final coreOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 70),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 25),
    ]).animate(controller);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (coreOpacity.value == 0) return const SizedBox.shrink();

        return Opacity(
          opacity: coreOpacity.value,
          child: Transform.scale(
            scale: coreScale.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow.withValues(alpha: 0.25),
                    blurRadius: 30,
                    spreadRadius: 8,
                    offset: const Offset(0, 15),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colorScheme.surface,
                    context.colorScheme.surfaceContainerHighest,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.hexagon_rounded,
                    size: AppSpacing.xxxl,
                    color: context.colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  Icon(
                    Icons.all_inclusive_rounded,
                    size: AppSpacing.xxl,
                    color: context.colorScheme.primary,
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

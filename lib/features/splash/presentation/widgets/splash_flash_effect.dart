import 'package:flutter/material.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class SplashFlashEffect extends StatelessWidget {
  final AnimationController controller;

  const SplashFlashEffect({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final flashOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 68),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 20),
    ]).animate(controller);

    final flashScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 68),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.5,
          end: 4.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 12,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 4.0, end: 4.0), weight: 20),
    ]).animate(controller);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (flashOpacity.value == 0 || flashScale.value == 0) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity: flashOpacity.value,
          child: Transform.scale(
            scale: flashScale.value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: context.colors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.surface.withValues(alpha: 0.8),
                    blurRadius: 50,
                    spreadRadius: 20,
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

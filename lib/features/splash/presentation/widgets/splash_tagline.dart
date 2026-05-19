import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class SplashTagline extends StatelessWidget {
  final AnimationController controller;

  const SplashTagline({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final Animation<double> taglineOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.85, 0.95, curve: Curves.easeIn),
          ),
        );

    final Animation<Offset> taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.85, 0.95, curve: Curves.easeOutCubic),
          ),
        );
    return FadeTransition(
      opacity: taglineOpacity,
      child: SlideTransition(
        position: taglineSlide,
        child: Column(
          children: [
            Text(
              context.t.splash.appName,
              style: context.headlineLarge.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.t.splash.tagline,
              style: context.bodyMedium.copyWith(
                color: context.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OnboardingSkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isVisible;

  const OnboardingSkipButton({
    required this.onPressed,
    required this.isVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: AppSpacing.md,
      right: AppSpacing.md,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          context.t.onboarding.skip,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

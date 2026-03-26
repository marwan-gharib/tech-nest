import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isEnabled;

  const CounterButton({
    required this.icon,
    required this.onPressed,
    required this.isEnabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: isEnabled ? onPressed : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: isEnabled
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isEnabled
                ? colorScheme.outlineVariant
                : colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isEnabled ? colorScheme.primary : colorScheme.outline,
        ),
      ),
    );
  }
}

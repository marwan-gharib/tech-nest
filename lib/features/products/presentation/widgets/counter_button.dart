import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

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
    final colorScheme = context.colorScheme;

    return InkWell(
      onTap: isEnabled ? onPressed : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: isEnabled
              ? context.colors.card
              : context.colors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isEnabled
                ? context.colors.border
                : context.colors.border.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isEnabled ? colorScheme.primary : context.colors.textSecondary,
        ),
      ),
    );
  }
}


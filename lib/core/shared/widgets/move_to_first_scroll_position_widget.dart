import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class MoveToFirstScrollPositionWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MoveToFirstScrollPositionWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      bottom: AppSpacing.xxl,
      right: AppSpacing.md,
      child: FloatingActionButton.small(
        onPressed: onTap,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Icon(Icons.keyboard_double_arrow_up_rounded),
      ),
    );
  }
}

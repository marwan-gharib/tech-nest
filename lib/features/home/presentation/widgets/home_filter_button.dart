import 'package:flutter/material.dart';

import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class HomeFilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HomeFilterButton({required this.onPressed, super.key});

  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: AppSpacing.homeFilterButtonWidth,
      width: AppSpacing.homeFilterButtonWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.button,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.tune_rounded,
          color: Colors.white,
          size: _iconSize,
        ),
      ),
    );
  }
}

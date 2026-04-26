import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class MoveToFirstScrollPositionWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MoveToFirstScrollPositionWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return FloatingActionButton.small(
      onPressed: onTap,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Icon(Icons.keyboard_double_arrow_up_rounded),
    );
  }
}


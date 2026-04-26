import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class ActiveFilterBadge extends StatelessWidget {
  final int count;

  const ActiveFilterBadge({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Container(
        key: ValueKey(count),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          '$count',
          style: context.labelSmall.copyWith(
            color: context.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}


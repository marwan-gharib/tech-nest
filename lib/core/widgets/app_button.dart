import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/scale_tap.dart';
import 'package:tech_nest/core/theme/app_radius.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final bool isEnabled;

  const AppButton({
    required this.onTap,
    required this.text,
    this.isEnabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          color: isEnabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

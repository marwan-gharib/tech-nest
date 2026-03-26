import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class ProductDetailsBackButton extends StatelessWidget {
  const ProductDetailsBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
      left: AppSpacing.md,
      child: CircleAvatar(
        backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

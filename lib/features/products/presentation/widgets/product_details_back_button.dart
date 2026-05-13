import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class ProductDetailsBackButton extends StatelessWidget {
  const ProductDetailsBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
      right: context.isArabic ? AppSpacing.md : null,
      left: context.isArabic ? null : AppSpacing.md,
      child: CircleAvatar(
        backgroundColor: context.colors.background.withValues(alpha: 0.8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
          color: context.colors.textPrimary,
        ),
      ),
    );
  }
}

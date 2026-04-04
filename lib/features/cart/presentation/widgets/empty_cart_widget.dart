import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "Your cart is empty",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              "Looks like you haven't added anything to your cart yet. Explore our products and find something you love!",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => context.go(Routes.homeScreenPath),
            child: const Text("Start Shopping"),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  static const double _badgeOffset = -6.0;
  static const double _minBadgeSize = AppSpacing.md * 2; // 16

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      right: _badgeOffset,
      top: _badgeOffset,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final int count = state is CartLoaded ? state.cart.items.length : 0;
          if (count == 0) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              minWidth: _minBadgeSize,
              minHeight: _minBadgeSize,
            ),
            child: Center(
              child: Text(
                count > 99 ? "99+" : count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}

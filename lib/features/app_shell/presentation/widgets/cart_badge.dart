import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  static const double _badgeOffset = -6.0;
  static const double _minBadgeSize = AppSpacing.md + 2;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: _badgeOffset,
      top: _badgeOffset,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final int count = state is CartLoaded ? state.cart.items.length : 0;
          if (count == 0) return const SizedBox.shrink();

          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            tween: Tween<double>(begin: 0.0, end: 1.0),
            key: ValueKey(count),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: _minBadgeSize,
                    minHeight: _minBadgeSize,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Center(
                    child: Text(
                      count > 99 ? "99+" : count.toString(),
                      style: context.labelSmall.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


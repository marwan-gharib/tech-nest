import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/widgets/app_badge.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  static const double _badgeOffset = -6.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: _badgeOffset,
      top: _badgeOffset,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final int count = state is CartLoaded ? state.cart.items.length : 0;

          return count > 0 ? AppBadge(count: count) : const SizedBox.shrink();
        },
      ),
    );
  }
}

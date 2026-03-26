import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:tech_nest/features/cart/presentation/widgets/order_summary.dart';

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
          child: Stack(
            children: [
              BlocConsumer<CartCubit, CartState>(
                listener: _listener,
                builder: _builder,
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: OrderSummary(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartFailed) {
      CustomSnackBar.show(context, message: state.message);
    }
  }

  Widget _builder(BuildContext context, CartState state) {
    if (state is CartLoaded) {
      final items = state.cart.items;

      return ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        itemBuilder: (context, index) {
          final item = items[index];
          AppLogger.log("Displaying cart item: ${item.id}");
          return CartItemCard(cartItem: item);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

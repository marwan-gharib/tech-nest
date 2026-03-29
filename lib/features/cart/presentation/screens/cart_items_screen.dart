import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
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
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state is CartLoaded || state is CartMutationFailed) {
                    return const Align(
                      alignment: Alignment.bottomCenter,
                      child: OrderSummary(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartMutationFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is CartFailed) {
      return Center(
        child: RemoteDataFailureView(
          failure: state.failure,
          onRetry: () => context.read<CartCubit>().fetchCart(),
        ),
      );
    }
    final items = switch (state) {
      CartLoaded(:final cart) => cart.items,
      CartMutationFailed(:final cart) => cart.items,
      _ => const <CartItem>[],
    };

    if (items.isEmpty) {
      return const Center(child: Text("Your cart is empty"));
    }

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.xxl * 3,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemCard(cartItem: item);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_items_skeleton_list.dart';
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
              BlocBuilder<CartCubit, CartState>(
                buildWhen: (previous, current) => previous != current,
                builder: _listBuilder,
              ),
              BlocBuilder<CartCubit, CartState>(
                buildWhen: (p, c) =>
                    c is CartLoaded || (p is CartLoaded && c is! CartLoaded),
                builder: (context, state) {
                  if (state is! CartLoaded) {
                    return const SizedBox.shrink();
                  }
                  return const Align(
                    alignment: Alignment.bottomCenter,
                    child: OrderSummary(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBuilder(BuildContext context, CartState state) {
    return switch (state) {
      CartInitial() || CartLoading() => const CartItemsSkeletonList(),
      CartNoConnection() => RemoteDataFailureView(
        isNoConnection: true,
        onRetry: () => context.read<CartCubit>().fetchCart(),
      ),
      CartError(:final message) => RemoteDataFailureView(
        isNoConnection: false,
        detailMessage: message,
        onRetry: () => context.read<CartCubit>().fetchCart(),
      ),
      CartLoaded(:final cart, :final mutationErrorMessage, :final mutationErrorIsNetwork) =>
        ListView.builder(
          itemCount:
              cart.items.length + (mutationErrorMessage != null ? 1 : 0),
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.xxl * 4,
          ),
          itemBuilder: (context, index) {
            if (mutationErrorMessage != null && index == 0) {
              return RemoteDataFailureView(
                isNoConnection: mutationErrorIsNetwork,
                compact: true,
                detailMessage: mutationErrorMessage,
                onRetry: () => context.read<CartCubit>().fetchCart(),
              );
            }
            final offset = mutationErrorMessage != null ? 1 : 0;
            final item = cart.items[index - offset];
            AppLogger.log("Displaying cart item: ${item.id}");
            return CartItemCard(cartItem: item);
          },
        ),
    };
  }
}

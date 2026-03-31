import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
          child: Stack(
            children: [
              BlocConsumer<CartCubit, CartState>(
                listenWhen: (p, c) =>
                    c is CartLoaded &&
                    c.mutationFailure != null &&
                    (p is! CartLoaded ||
                        p.mutationFailure != c.mutationFailure),
                listener: (context, state) {
                  if (state is CartLoaded && state.mutationFailure != null) {
                    CustomSnackBar.showError(
                      context,
                      failure: state.mutationFailure!,
                    );
                    context.read<CartCubit>().clearMutationError();
                  }
                },
                buildWhen: (previous, current) => previous != current,
                builder: _listBuilder,
              ),
              BlocBuilder<CartCubit, CartState>(
                buildWhen: (p, c) =>
                    c is CartLoaded || (p is CartLoaded && c is! CartLoaded),
                builder: (context, state) {
                  if (state is! CartLoaded || state.cart.items.isEmpty) {
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
      CartFailed(:final failure) => RemoteDataFailureView(
        failure: failure,
        onRetry: () => context.read<CartCubit>().fetchCart(),
      ),
      CartLoaded(:final cart) =>
        cart.items.isEmpty
            ? _buildEmptyCartUI(context)
            : ListView.builder(
                itemCount: cart.items.length,
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.xxl * 4.5,
                ),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  AppLogger.log("Displaying cart item: ${item.id}");
                  return CartItemCard(cartItem: item);
                },
              ),
    };
  }

  Widget _buildEmptyCartUI(BuildContext context) {
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

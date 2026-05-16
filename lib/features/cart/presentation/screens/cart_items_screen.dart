import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/animations/animate_once_wrapper.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/widgets/no_results_found_view.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_items_skeleton_list.dart';
import 'package:tech_nest/features/cart/presentation/widgets/checkout_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  @override
  void initState() {
    super.initState();
    if (context.read<CartCubit>().state is! CartLoaded) {
      context.read<CartCubit>().fetchCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(context.t.cart.title)),
        body: BlocListener<LocaleCubit, LocaleState>(
          listenWhen: (previous, current) => previous.locale != current.locale,
          listener: (context, state) {
            context.read<CartCubit>().fetchCart();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
            child: Stack(
              children: [
                RepaintBoundary(
                  child: BlocConsumer<CartCubit, CartState>(
                    listenWhen: (p, c) =>
                        c is CartLoaded &&
                        c.mutationFailure != null &&
                        (p is! CartLoaded ||
                            p.mutationFailure != c.mutationFailure),
                    listener: (context, state) {
                      if (state is CartLoaded &&
                          state.mutationFailure != null) {
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
                ),
                BlocBuilder<CartCubit, CartState>(
                  buildWhen: (p, c) =>
                      c is CartLoaded || (p is CartLoaded && c is! CartLoaded),
                  builder: (context, state) {
                    if (state is! CartLoaded || state.cart.items.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: CheckoutButton(
                        totalPrice: state.cart.grandTotal.toDouble(),
                        onPressed: () => context.pushNamed(RouteNames.checkout),
                      ),
                    );
                  },
                ),
              ],
            ),
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
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoResultsFoundView(
                    title: context.t.cart.empty,
                    message: context.t.cart.emptyDesc,
                    icon: Icons.shopping_basket_outlined,
                  ),
                  ElevatedButton(
                    onPressed: () => context.goNamed(RouteNames.home),
                    child: Text(context.t.cart.startShopping),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: () => context.read<CartCubit>().fetchCart(),
                child: ListView.builder(
                  itemCount: cart.items.length,
                  padding: const EdgeInsets.only(
                    top: AppSpacing.lg,
                    bottom: AppSpacing.xxl * 4.5,
                  ),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return AnimateOnceWrapper(
                      key: ValueKey(item.id),
                      namespace: 'cart_items',
                      id: 'cart_item_${item.id}',
                      child: CartItemCard(
                        key: ValueKey(item.id),
                        cartItem: item,
                      ),
                      animationBuilder: (context, child) => FadeInSlide(
                        duration: const Duration(milliseconds: 400),
                        delay: Duration(milliseconds: index * 70),
                        child: child,
                      ),
                    );
                  },
                ),
              ),
    };
  }
}

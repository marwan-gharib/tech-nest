import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/shared/presentation/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';

class ChangeCartItemCount extends StatelessWidget {
  final int cartId;
  final int initialCount;

  const ChangeCartItemCount({
    required this.cartId,
    required this.initialCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        _buildCounterButton(
          context,
          icon: Icons.remove,
          onPressed: () => _decrement(context),
        ),
        BlocListener<UpdateItemQuantityCubit, UpdateItemQuantityState>(
          listener: _listener,
          child: BlocBuilder<CartCubit, CartState>(builder: _builder),
        ),
        _buildCounterButton(
          context,
          icon: Icons.add,
          onPressed: () => _increment(context),
        ),
      ],
    );
  }

  Widget _buildCounterButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) => InkWell(
    onTap: onPressed,
    child: Container(
      height: 26,
      width: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: Theme.of(context).shadowColor),
    ),
  );

  void _listener(BuildContext context, UpdateItemQuantityState state) {
    if (state is UpdateItemQuantitySuccess) {
      context.read<CartCubit>().updateItemQuantityLocally(
        id: cartId,
        quantity: state.updatedQuantity,
      );
    } else if (state is UpdateItemQuantityFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, CartState state) {
    if (state is! CartLoaded) {
      return const SizedBox();
    }

    final item = state.cart.items.firstWhere((item) => item.id == cartId);

    return Text(
      "${item.quantity}",
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
        fontSize: 15,
        color: Theme.of(context).shadowColor,
      ),
    );
  }

  void _decrement(BuildContext context) async {
    final cartCubit = context.read<CartCubit>();
    final updateCubit = context.read<UpdateItemQuantityCubit>();

    if (updateCubit.state is UpdateItemQuantityLoading) return;

    final cartState = cartCubit.state;
    if (cartState is! CartLoaded) return;

    final currentItem = cartState.cart.items.firstWhere(
      (item) => item.id == cartId,
    );
    if (currentItem.quantity > 1) {
      final newQuantity = currentItem.quantity - 1;
      await updateCubit.updateQuantity(
        cartId: cartId,
        updatedQuantity: newQuantity,
      );
    }
  }

  void _increment(BuildContext context) async {
    final cartCubit = context.read<CartCubit>();
    final updateCubit = context.read<UpdateItemQuantityCubit>();

    if (updateCubit.state is UpdateItemQuantityLoading) return;

    final cartState = cartCubit.state;
    if (cartState is! CartLoaded) return;

    final currentItem = cartState.cart.items.firstWhere(
      (item) => item.id == cartId,
    );
    final newQuantity = currentItem.quantity + 1;
    await updateCubit.updateQuantity(
      cartId: cartId,
      updatedQuantity: newQuantity,
    );
  }
}

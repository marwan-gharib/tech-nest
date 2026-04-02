import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/shared/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';

class ChangeCartItemCount extends StatefulWidget {
  final int cartId;
  final int initialCount;

  const ChangeCartItemCount({
    required this.cartId,
    required this.initialCount,
    super.key,
  });

  @override
  State<ChangeCartItemCount> createState() => _ChangeCartItemCountState();
}

class _ChangeCartItemCountState extends State<ChangeCartItemCount> {
  late final ValueNotifier<int> _counterNotifier;

  @override
  void initState() {
    super.initState();
    _counterNotifier = ValueNotifier<int>(widget.initialCount);
  }

  @override
  void dispose() {
    _counterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        _buildCounterButton(context, icon: Icons.remove, onPressed: _decrement),
        BlocConsumer<UpdateItemQuantityCubit, UpdateItemQuantityState>(
          listener: _listener,
          builder: _builder,
        ),
        _buildCounterButton(context, icon: Icons.add, onPressed: _increment),
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
      _counterNotifier.value = state.updatedQuantity;
      context.read<CartCubit>().updateItemQuantityLocally(
        id: widget.cartId,
        quantity: state.updatedQuantity,
      );
    } else if (state is UpdateItemQuantityFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, UpdateItemQuantityState state) {
    return ValueListenableBuilder<int>(
      valueListenable: _counterNotifier,
      builder: (context, counter, _) {
        return Text(
          "$counter",
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 15,
            color: Theme.of(context).shadowColor,
          ),
        );
      },
    );
  }

  void _decrement() async {
    if (context.read<UpdateItemQuantityCubit>().state
        is UpdateItemQuantityLoading) {
      return;
    }

    if (_counterNotifier.value > 1) {
      final newQuantity = _counterNotifier.value - 1;
      await context.read<UpdateItemQuantityCubit>().updateQuantity(
        cartId: widget.cartId,
        updatedQuantity: newQuantity,
      );
    }
  }

  void _increment() async {
    if (context.read<UpdateItemQuantityCubit>().state
        is UpdateItemQuantityLoading) {
      return;
    }

    final newQuantity = _counterNotifier.value + 1;
    await context.read<UpdateItemQuantityCubit>().updateQuantity(
      cartId: widget.cartId,
      updatedQuantity: newQuantity,
    );
  }
}

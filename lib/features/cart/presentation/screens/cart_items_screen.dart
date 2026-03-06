import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_item_card.dart';

class CartItemsScreen extends StatelessWidget {
  const CartItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(title: const Text("Cart")),
        body: BlocConsumer<CartCubit, CartState>(
          listener: _listener,
          builder: _builder,
        ),
      ),
    );
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartFailed) {
      customSnackBar(context, message: state.message);
    }
  }

  Widget _builder(BuildContext context, CartState state) {
    if (state is CartLoaded) {
      final items = state.cart.items;

      return ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        itemBuilder: (context, index) {
          final item = items[index];
          Logger.logg(item.id.toString());
          return CartItemCard(cartItem: item);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

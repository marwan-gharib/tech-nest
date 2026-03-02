import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/fetch_cart_items_cubit/fetch_cart_items_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_item_card.dart';

class CartItemsScreen extends StatelessWidget {
  const CartItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Cart")),
        body: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          child: BlocConsumer<FetchCartItemsCubit, FetchCartItemsState>(
            listener: _listener,
            builder: _builder,
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, FetchCartItemsState state) {
    if (state is FetchCartItemsFailed) {
      customSnackBar(context, message: state.message);
    }
  }

  Widget _builder(BuildContext context, FetchCartItemsState state) {
    if (state is FetchCartItemsLoaded) {
      final items = state.cartItems;

      return ListView.builder(
        itemBuilder: (context, index) {
          final item = items[index];
          return CartItemCard(product: item.product);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

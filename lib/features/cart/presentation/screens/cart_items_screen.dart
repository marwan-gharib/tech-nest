import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/cubits/cart_cubit/cart_cubit.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_details_widget.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_item_card.dart';

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  @override
  void initState() {
    context.read<CartCubit>().fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              BlocConsumer<CartCubit, CartState>(
                listener: _listener,
                builder: _builder,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 14,
                    children: [
                      Text(
                        "Order Summary",
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(fontSize: 18),
                      ),
                      const CartDetailsWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 20),
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

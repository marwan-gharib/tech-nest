import 'package:flutter/material.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class AddToCartAction extends StatelessWidget {
  final bool isLoading;
  final bool isInCart;
  final VoidCallback onAdd;
  final bool isAvailable;

  const AddToCartAction({
    required this.isLoading,
    required this.isInCart,
    required this.onAdd,
    required this.isAvailable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isAvailable ? onAdd : null,
        child: Text(
          isInCart
              ? context.t.products.updateCart
              : context.t.products.addToCart,
        ),
      ),
    );
  }
}

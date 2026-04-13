import 'package:flutter/material.dart';
import 'package:tech_nest/core/shared/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class AddToCartAction extends StatelessWidget {
  final CartState state;
  final int productId;
  final VoidCallback onAdd;
  final bool isAvailable;

  const AddToCartAction({
    required this.state,
    required this.productId,
    required this.onAdd,
    required this.isAvailable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (state is CartLoading ||
        (state is CartLoaded && (state as CartLoaded).isMutating)) {
      return const Center(child: CircularProgressIndicator());
    }

    final bool isInCart =
        state is CartLoaded &&
        (state as CartLoaded).cart.items.any(
          (item) => item.product.id == productId,
        );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isAvailable ? onAdd : null,
        child: Text(isInCart
            ? context.t.products.updateCart
            : context.t.products.addToCart),
      ),
    );
  }
}

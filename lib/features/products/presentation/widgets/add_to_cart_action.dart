import 'package:flutter/material.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

class AddToCartAction extends StatelessWidget {
  final CartState state;
  final VoidCallback onAdd;
  final bool isAvailable;

  const AddToCartAction({
    required this.state,
    required this.onAdd,
    required this.isAvailable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (state is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state case CartLoaded(isMutating: true)) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isAvailable ? onAdd : null,
        child: const Text("Add to Cart"),
      ),
    );
  }
}

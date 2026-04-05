import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/shared/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/shared/presentation/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';

class RemoveCartItemButton extends StatelessWidget {
  final int cartId;

  const RemoveCartItemButton({required this.cartId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteCartItemCubit, DeleteCartItemState>(
      listener: _listener,
      builder: _builder,
    );
  }

  void _listener(BuildContext context, DeleteCartItemState state) {
    if (state is DeleteCartItemSuccess) {
      context.read<CartCubit>().removeItemLocally(id: state.id);
    } else if (state is DeleteCartItemFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, DeleteCartItemState state) {
    return GestureDetector(
      onTap: () =>
          context.read<DeleteCartItemCubit>().removeItem(cartId: cartId),
      child: Icon(
        CupertinoIcons.delete,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

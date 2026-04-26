import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';

class RemoveCartItemButton extends StatelessWidget {
  final int cartId;
  final VoidCallback onDeleteSuccess;

  const RemoveCartItemButton({
    required this.cartId,
    required this.onDeleteSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteCartItemCubit, DeleteCartItemState>(
      listener: _listener,
      builder: _builder,
    );
  }

  void _listener(BuildContext context, DeleteCartItemState state) {
    if (state is DeleteCartItemSuccess) {
      onDeleteSuccess();
    } else if (state is DeleteCartItemFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, DeleteCartItemState state) {
    return GestureDetector(
      onTap: state is DeleteCartItemLoading
          ? null
          : () => context.read<DeleteCartItemCubit>().removeItem(cartId: cartId),
      child: state is DeleteCartItemLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.error,
              ),
            )
          : Icon(
              CupertinoIcons.delete,
              color: context.colors.error,
            ),
    );
  }
}


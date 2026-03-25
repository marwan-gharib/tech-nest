import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/widgets/build_price.dart';

class CartDetailsWidget extends StatelessWidget {
  const CartDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _dataRow(
                context,
                label: 'Items',
                number: state.cart.totalQuantity,
              ),
              _dataRow(
                context,
                label: 'Subtotal',
                number: state.cart.totalPrice,
                isPrice: true,
              ),
              _dataRow(
                context,
                label: 'Delivery Charges',
                number: state.cart.deliveryCharges,
                isPrice: true,
              ),
              Divider(color: Theme.of(context).hintColor),
              _dataRow(
                context,
                label: 'Total',
                number: state.cart.grandTotal,
                isPrice: true,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _dataRow(
    BuildContext context, {
    required String label,
    required int number,
    bool isPrice = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color:
                  color ?? Theme.of(context).shadowColor.withValues(alpha: 0.6),
            ),
          ),
          isPrice
              ? BuildPrice(
                  price: number.toDouble(),
                  size: 16,
                  numberColor: color,
                )
              : Text(
                  number.toString(),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        color ??
                        Theme.of(context).shadowColor.withValues(alpha: 0.6),
                  ),
                ),
        ],
      ),
    );
  }
}

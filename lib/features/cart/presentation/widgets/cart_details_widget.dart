import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/widgets/build_price.dart';

class CartDetailsWidget extends StatelessWidget {
  const CartDetailsWidget({super.key});

  static const double _priceSize = 16.0;
  static const double _labelAlpha = 0.6;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm + 2,
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
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge;
    final secondaryColor = theme.shadowColor.withValues(alpha: _labelAlpha);

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm + 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle?.copyWith(
              color: color ?? secondaryColor,
            ),
          ),
          isPrice
              ? BuildPrice(
                  price: number.toDouble(),
                  size: _priceSize,
                  numberColor: color,
                )
              : Text(
                  number.toString(),
                  style: labelStyle?.copyWith(
                    fontSize: _priceSize,
                    fontWeight: FontWeight.w500,
                    color: color ?? secondaryColor,
                  ),
                ),
        ],
      ),
    );
  }
}

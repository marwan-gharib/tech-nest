import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/build_price.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class CartDetailsWidget extends StatelessWidget {
  final Cart cart;
  const CartDetailsWidget({required this.cart, super.key});

  static const double _priceSize = 16.0;
  static const double _titleSize = 14.0;
  static const double _labelAlpha = 0.6;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm + 2,
      children: [
        _dataRow(
          context,
          label: context.t.cart.items,
          number: cart.totalQuantity,
        ),
        _dataRow(
          context,
          label: context.t.cart.subtotal,
          number: cart.totalPrice,
          isPrice: true,
        ),
        _dataRow(
          context,
          label: context.t.cart.delivery,
          number: cart.deliveryCharges,
          isPrice: true,
          isFree: cart.deliveryCharges == 0,
        ),
        Divider(color: context.colors.divider),
        _dataRow(
          context,
          label: context.t.cart.total,
          number: cart.grandTotal,
          isPrice: true,
          color: context.colors.textPrimary,
        ),
      ],
    );
  }

  Widget _dataRow(
    BuildContext context, {
    required String label,
    required int number,
    bool isPrice = false,
    bool isFree = false,
    Color? color,
  }) {
    final labelStyle = context.labelLarge;
    final secondaryColor = context.colors.textSecondary.withValues(alpha: _labelAlpha);

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm + 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.labelLarge.copyWith(fontSize: _titleSize),
          ),
          isFree
              ? Text(
                  context.t.cart.free,
                  style: labelStyle.copyWith(
                    fontSize: _priceSize,
                    fontWeight: FontWeight.w500,
                    color: color ?? secondaryColor,
                  ),
                )
              : isPrice
              ? BuildPrice(
                  price: number.toDouble(),
                  size: _priceSize,
                  numberColor: color,
                )
              : Text(
                  number.toString(),
                  style: labelStyle.copyWith(
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


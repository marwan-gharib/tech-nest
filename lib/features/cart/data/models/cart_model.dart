import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/cart/data/models/cart_item_model.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';

class CartModel {
  final List<CartItemModel> items;
  final int totalQuantity;
  final int totalPrice;
  final int deliveryCharges;
  final int grandTotal;

  CartModel({
    required this.items,
    required this.totalQuantity,
    required this.totalPrice,
    required this.deliveryCharges,
    required this.grandTotal,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json[ApiKeys.items] as List)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalQuantity: json[ApiKeys.totalQuantity],
      totalPrice: json[ApiKeys.totalPrice],
      deliveryCharges: json[ApiKeys.deliveryCharges],
      grandTotal: json[ApiKeys.grandTotal],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.items: items,
      ApiKeys.totalQuantity: totalQuantity,
      ApiKeys.totalPrice: totalPrice,
      ApiKeys.deliveryCharges: deliveryCharges,
      ApiKeys.grandTotal: grandTotal,
    };
  }

  Cart toEntity() {
    return Cart(
      items: items.map((item) => item.toEntity()).toList(),
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
      deliveryCharges: deliveryCharges,
      grandTotal: grandTotal,
    );
  }
}

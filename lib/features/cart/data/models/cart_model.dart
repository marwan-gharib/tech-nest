import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/products/data/models/product_model.dart';

class CartModel {
  final int id;
  final int quantity;
  final ProductModel productModel;

  CartModel({
    required this.id,
    required this.quantity,
    required this.productModel,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: int.parse(json[ApiKeys.id].toString()),
      quantity: json[ApiKeys.quantity] as int,
      productModel: ProductModel.fromJson(json[ApiKeys.product]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.quantity: quantity,
      ApiKeys.product: productModel.toJson(),
    };
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      quantity: quantity,
      product: productModel.toEntity(),
    );
  }
}

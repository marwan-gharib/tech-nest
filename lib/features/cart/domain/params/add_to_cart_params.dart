import 'package:tech_nest/core/constants/api_keys.dart';

class AddToCartParams {
  final int productId;
  final int quantity;

  AddToCartParams({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {ApiKeys.productId: productId, ApiKeys.quantity: quantity};
  }
}

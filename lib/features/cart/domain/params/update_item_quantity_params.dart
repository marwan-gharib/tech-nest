import 'package:tech_nest/core/constants/api_keys.dart';

class UpdateItemQuantityParams {
  final int cartId;
  final int quantity;

  UpdateItemQuantityParams({required this.cartId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {ApiKeys.id: cartId, ApiKeys.quantity: quantity};
  }
}

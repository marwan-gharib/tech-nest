import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

abstract class CartRepository {
  Future<ApiResult<Cart>> getCartItems();

  Future<ApiResult<CartItem>> addToCart({
    required AddToCartParams params,
  });

  Future<ApiResult<int>> removeFromCart({required int cartId});

  Future<ApiResult<int>> updateItemQuantity({
    required UpdateItemQuantityParams params,
  });

  Future<ApiResult<Cart>> clearCart();
}

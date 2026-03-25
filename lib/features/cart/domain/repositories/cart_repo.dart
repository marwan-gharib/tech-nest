import 'package:tech_nest/core/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/entities/cart.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

abstract class CartRepo {
  Future<CartItem> addToCart({required AddToCartParams params});

  Future<Cart> getCartItems();

  Future<int> removeFromCart({required int cartId});

  Future<int> updateItemQuantity({required UpdateItemQuantityParams params});
}

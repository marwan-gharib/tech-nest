import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';

abstract class CartRepo {
  Future<void> addToCart({required AddToCartParams params});

  Future<List<CartItem>> getCartItems();

  Future<void> removeFromCart({required int cartId});
}

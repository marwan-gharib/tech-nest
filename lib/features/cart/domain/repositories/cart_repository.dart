import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCartItems();

  Future<Either<Failure, CartItem>> addToCart({
    required AddToCartParams params,
  });

  Future<Either<Failure, int>> removeFromCart({required int cartId});

  Future<Either<Failure, int>> updateItemQuantity({
    required UpdateItemQuantityParams params,
  });

  Future<Either<Failure, Unit>> clearCart();
}

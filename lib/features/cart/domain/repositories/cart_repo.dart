import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/entities/cart.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

abstract class CartRepo {
  Future<Either<Failure, CartItem>> addToCart({
    required AddToCartParams params,
  });

  Future<Either<Failure, Cart>> getCartItems();

  Future<Either<Failure, int>> removeFromCart({required int cartId});

  Future<Either<Failure, int>> updateItemQuantity({
    required UpdateItemQuantityParams params,
  });
}

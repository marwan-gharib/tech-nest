import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/cart_entity.dart';
import 'package:tech_nest/core/shared/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/core/shared/domain/params/add_to_cart_params.dart';

abstract class CartSharedRepository {
  Future<Either<Failure, Cart>> getCartItems();

  Future<Either<Failure, CartItem>> addToCart({
    required AddToCartParams params,
  });
}

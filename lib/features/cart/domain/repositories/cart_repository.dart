import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

abstract class CartRepository {
  Future<Either<Failure, int>> removeFromCart({required int cartId});

  Future<Either<Failure, int>> updateItemQuantity({
    required UpdateItemQuantityParams params,
  });
  Future<Either<Failure, Unit>> clearCart();
}

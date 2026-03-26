import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class AddToCartUsecase {
  final CartRepo _repo;

  AddToCartUsecase(this._repo);

  Future<Either<Failure, CartItem>> call({
    required AddToCartParams params,
  }) async {
    return await _repo.addToCart(params: params);
  }
}

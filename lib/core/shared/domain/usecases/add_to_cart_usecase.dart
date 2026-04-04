import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/core/shared/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/core/shared/domain/repositories/cart_shared_repository.dart';

class AddToCartUsecase {
  final CartSharedRepository _repo;

  AddToCartUsecase(this._repo);

  Future<Either<Failure, CartItem>> call({
    required AddToCartParams params,
  }) async {
    return await _repo.addToCart(params: params);
  }
}

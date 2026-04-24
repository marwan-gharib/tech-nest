import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUsecase {
  final CartRepository _repo;

  GetCartItemsUsecase(this._repo);

  Future<Either<Failure, Cart>> call() async {
    return await _repo.getCartItems();
  }
}

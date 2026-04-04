import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/cart_entity.dart';
import 'package:tech_nest/core/shared/domain/repositories/cart_shared_repository.dart';

class GetCartItemsUsecase {
  final CartSharedRepository _repo;

  GetCartItemsUsecase(this._repo);

  Future<Either<Failure, Cart>> call() async {
    return await _repo.getCartItems();
  }
}

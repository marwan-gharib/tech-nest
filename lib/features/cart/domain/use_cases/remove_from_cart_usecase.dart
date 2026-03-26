import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class RemoveFromCartUsecase {
  final CartRepo _repo;

  RemoveFromCartUsecase(this._repo);

  Future<Either<Failure, int>> call({required int cartId}) async {
    return await _repo.removeFromCart(cartId: cartId);
  }
}

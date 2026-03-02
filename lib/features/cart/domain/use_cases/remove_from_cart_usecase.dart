import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class RemoveFromCartUsecase {
  final CartRepo _repo;

  RemoveFromCartUsecase(this._repo);

  Future<Either<Failure, void>> call({required int cartId}) async {
    try {
      await _repo.removeFromCart(cartId: cartId);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

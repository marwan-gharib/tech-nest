import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class RemoveFromCartUsecase {
  final CartRepo _repo;

  RemoveFromCartUsecase(this._repo);

  Future<Either<Failure, int>> call({required int cartId}) async {
    try {
      return Right(await _repo.removeFromCart(cartId: cartId));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

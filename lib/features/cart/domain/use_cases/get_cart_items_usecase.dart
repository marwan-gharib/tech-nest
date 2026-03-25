import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failures.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/cart/domain/entities/cart.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class GetCartItemsUsecase {
  final CartRepo _repo;

  GetCartItemsUsecase(this._repo);

  Future<Either<Failure, Cart>> call() async {
    try {
      return Right(await _repo.getCartItems());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

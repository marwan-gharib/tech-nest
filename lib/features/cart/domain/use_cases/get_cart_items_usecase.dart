import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
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

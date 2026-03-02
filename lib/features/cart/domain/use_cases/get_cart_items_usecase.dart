import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class GetCartItemsUsecase {
  final CartRepo _repo;

  GetCartItemsUsecase(this._repo);

  Future<Either<Failure, List<CartItem>>> call() async {
    try {
      return Right(await _repo.getCartItems());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

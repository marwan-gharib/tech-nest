import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class UpdateItemQuantityUsecase {
  final CartRepo _repo;

  UpdateItemQuantityUsecase(this._repo);

  Future<Either<Failure, int>> call({
    required UpdateItemQuantityParams params,
  }) async {
    try {
      return Right(await _repo.updateItemQuantity(params: params));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

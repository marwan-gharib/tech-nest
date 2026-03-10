import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/core/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class AddToCartUsecase {
  final CartRepo _repo;

  AddToCartUsecase(this._repo);

  Future<Either<Failure, CartItem>> call({
    required AddToCartParams params,
  }) async {
    try {
      return Right(await _repo.addToCart(params: params));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

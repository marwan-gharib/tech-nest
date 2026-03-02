import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/entities/product_entity.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/core/params/products_params.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';

class GetProductsUsecase {
  final ProductsRepo _repo;

  GetProductsUsecase(this._repo);

  Future<Either<Failure, List<Product>>> call({
    required ProductsParams params,
  }) async {
    try {
      final products = await _repo.getProducts(params: params);

      return Right(products);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

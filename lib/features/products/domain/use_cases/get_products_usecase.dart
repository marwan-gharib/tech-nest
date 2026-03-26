import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';

class GetProductsUsecase {
  final ProductsRepo _repo;

  GetProductsUsecase(this._repo);

  Future<Either<Failure, List<ProductEntity>>> call({
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

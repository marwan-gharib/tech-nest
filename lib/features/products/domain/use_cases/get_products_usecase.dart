import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';

class GetProductsUsecase {
  final ProductsRepo _repo;

  GetProductsUsecase(this._repo);

  Future<Either<Failure, List<ProductEntity>>> call({
    int? categoryId,
    int page = 1,
  }) async {
    try {
      final products = await _repo.getProducts(
        categoryId: categoryId,
        page: page,
      );

      return Right(products);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

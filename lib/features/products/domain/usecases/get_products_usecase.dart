import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/shared/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/domain/params/products_params.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';

class GetProductsUsecase {
  final ProductsRepository _repo;

  GetProductsUsecase(this._repo);

  Future<Either<Failure, List<ProductEntity>>> call({
    required ProductsParams params,
  }) async {
    return await _repo.getProducts(params: params);
  }
}

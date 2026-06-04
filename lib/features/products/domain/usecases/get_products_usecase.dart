import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';

class GetProductsUsecase {
  final ProductsRepository _repo;

  GetProductsUsecase(this._repo);

  Future<ApiResult<List<ProductEntity>>> call({
    required ProductsParams params,
  }) async {
    return await _repo.getProducts(params: params);
  }
}

import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';

abstract class ProductsRepository {
  Future<ApiResult<List<ProductEntity>>> getProducts({
    required ProductsParams params,
  });

  Future<ApiResult<ProductEntity>> getProduct({required int productId});

  Future<ApiResult<List<String>>> searchSuggestions({
    required String searchQuery,
  });
}

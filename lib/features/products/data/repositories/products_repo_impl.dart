import 'package:tech_nest/features/products/data/data_source/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';

class ProductsRepoImpl extends ProductsRepo {
  final ProductsRemoteDataSource _dataSource;

  ProductsRepoImpl(this._dataSource);

  @override
  Future<List<ProductEntity>> getProducts({
    required ProductsParams params,
  }) async {
    final productsModel = await _dataSource.getProducts(params: params);

    return productsModel.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<String>> searchSuggestions({required String searchQuery}) async {
    return await _dataSource.searchSuggestions(searchQuery);
  }
}

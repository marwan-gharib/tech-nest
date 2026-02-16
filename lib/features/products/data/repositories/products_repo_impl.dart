import 'package:tech_nest/features/products/data/data_source/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';

class ProductsRepoImpl extends ProductsRepo {
  final ProductsRemoteDataSource _dataSource;

  ProductsRepoImpl(this._dataSource);

  @override
  Future<List<ProductEntity>> getProducts({int? categoryId}) async {
    final productsModel = await _dataSource.getProducts(categoryId: categoryId);

    return productsModel.map((model) => model.toEntity()).toList();
  }
}

import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';

abstract class ProductsRepo {
  Future<List<ProductEntity>> getProducts({required ProductsParams params});
  Future<List<String>> searchSuggestions({required String searchQuery});
}

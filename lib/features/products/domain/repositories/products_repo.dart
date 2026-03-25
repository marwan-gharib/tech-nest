import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/domain/params/products_params.dart';

abstract class ProductsRepo {
  Future<List<Product>> getProducts({required ProductsParams params});
  Future<List<String>> searchSuggestions({required String searchQuery});
}

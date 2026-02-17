import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

abstract class ProductsRepo {
  Future<List<ProductEntity>> getProducts({int? categoryId, int page = 1});
}

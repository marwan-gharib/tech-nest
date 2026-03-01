import 'package:tech_nest/core/entities/category_entity.dart';

abstract class CategoriesRepo {
  Future<List<CategoryEntity>> getCategories();
}

import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';

abstract class CategoriesRepo {
  Future<List<CategoryEntity>> getCategories();
}

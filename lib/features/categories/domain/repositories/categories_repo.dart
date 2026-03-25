import 'package:tech_nest/core/domain/entities/category_entity.dart';

abstract class CategoriesRepo {
  Future<List<Category>> getCategories();
}

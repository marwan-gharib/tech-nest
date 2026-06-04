import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';

abstract class CategoriesRepository {
  Future<ApiResult<List<CategoryEntity>>> getCategories();
}

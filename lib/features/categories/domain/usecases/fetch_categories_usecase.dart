import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repository.dart';

class FetchCategoriesUsecase {
  final CategoriesRepository _repo;

  FetchCategoriesUsecase(this._repo);

  Future<ApiResult<List<CategoryEntity>>> call() async {
    return await _repo.getCategories();
  }
}

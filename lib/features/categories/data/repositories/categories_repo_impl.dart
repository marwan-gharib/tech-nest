import 'package:tech_nest/features/categories/data/data_source/remote/categories_remote_data_source.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repo.dart';

class CategoriesRepoImpl extends CategoriesRepo {
  final CategoriesRemoteDataSource _dataSource;

  CategoriesRepoImpl(this._dataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categoriesModels = await _dataSource.getCategories();

    return categoriesModels
        .map((categoryModel) => categoryModel.toEntity())
        .toList();
  }
}

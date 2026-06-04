import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repository.dart';
import 'package:tech_nest/features/categories/data/datasources/remote/categories_remote_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDatasource _dataSource;

  CategoriesRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async {
    try {
      final categoriesModels = await _dataSource.getCategories();

      return ApiSuccess(
        categoriesModels
            .map((categoryModel) => categoryModel.toEntity())
            .toList(),
      );
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }
}

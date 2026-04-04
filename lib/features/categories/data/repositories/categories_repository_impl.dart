import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/shared/domain/entities/category_entity.dart';
import 'package:tech_nest/core/shared/domain/repositories/categories_repository.dart';
import 'package:tech_nest/features/categories/data/datasources/remote/categories_remote_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDatasource _dataSource;

  CategoriesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categoriesModels = await _dataSource.getCategories();

      return Right(
        categoriesModels
            .map((categoryModel) => categoryModel.toEntity())
            .toList(),
      );
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

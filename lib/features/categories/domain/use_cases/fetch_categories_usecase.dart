import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/entities/category_entity.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repo.dart';

class FetchCategoriesUsecase {
  final CategoriesRepo _repo;

  FetchCategoriesUsecase(this._repo);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    try {
      return Right(await _repo.getCategories());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

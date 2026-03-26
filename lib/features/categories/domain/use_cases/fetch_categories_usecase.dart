import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/domain/entities/category_entity.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repo.dart';

class FetchCategoriesUsecase {
  final CategoriesRepo _repo;

  FetchCategoriesUsecase(this._repo);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await _repo.getCategories();
  }
}

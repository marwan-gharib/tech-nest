import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/domain/entities/category_entity.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}

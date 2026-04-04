import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/domain/params/products_params.dart';

abstract class ProductsSharedRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required ProductsParams params,
  });

  Future<Either<Failure, List<String>>> searchSuggestions({
    required String searchQuery,
  });
}

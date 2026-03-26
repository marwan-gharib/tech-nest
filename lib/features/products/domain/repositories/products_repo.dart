import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/domain/params/products_params.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

abstract class ProductsRepo {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required ProductsParams params,
  });
  Future<Either<Failure, List<String>>> searchSuggestions({
    required String searchQuery,
  });
}

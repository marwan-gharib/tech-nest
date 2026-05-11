import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';

class GetProductUsecase {
  final ProductsRepository _repository;

  GetProductUsecase(this._repository);

  Future<Either<Failure, ProductEntity>> call(int productId) async {
    return await _repository.getProduct(productId: productId);
  }
}

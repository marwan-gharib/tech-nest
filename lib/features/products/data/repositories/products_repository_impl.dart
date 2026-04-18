import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/shared/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/domain/params/products_params.dart';
import 'package:tech_nest/core/shared/domain/repositories/products_shared_repository.dart';
import 'package:tech_nest/features/products/data/datasources/remote/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsSharedRepository {
  final ProductsRemoteDatasource _dataSource;

  ProductsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required ProductsParams params,
  }) async {
    try {
      final productsModel = await _dataSource.getProducts(params: params);
      return Right(productsModel.map((model) => model.toEntity()).toList());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> searchSuggestions({
    required String searchQuery,
  }) async {
    try {
      final suggestions = await _dataSource.searchSuggestions(searchQuery);
      return Right(suggestions);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

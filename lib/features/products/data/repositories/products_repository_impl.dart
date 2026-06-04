import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDatasource _dataSource;

  ProductsRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<List<ProductEntity>>> getProducts({
    required ProductsParams params,
  }) async {
    try {
      final productsModel = await _dataSource.getProducts(params: params);
      return ApiSuccess(productsModel.map((model) => model.toEntity()).toList());
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<ProductEntity>> getProduct({
    required int productId,
  }) async {
    try {
      final productModel = await _dataSource.getProduct(productId: productId);
      return ApiSuccess(productModel.toEntity());
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<List<String>>> searchSuggestions({
    required String searchQuery,
  }) async {
    try {
      final suggestions = await _dataSource.searchSuggestions(searchQuery);
      return ApiSuccess(suggestions);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }
}

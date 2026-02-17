import 'dart:developer';

import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/features/products/data/models/product_model.dart';

class ProductsRemoteDataSource {
  final ApiConsumer _api;

  ProductsRemoteDataSource(this._api);

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    int page = 1,
  }) async {
    try {
      final response = await _api.get(
        Endpoints.productsList,
        data: categoryId != null ? {ApiKeys.categoryID: categoryId} : null,
        queryParameters: {ApiKeys.limit: 10, ApiKeys.page: page},
      );

      if (response != null) {
        final List? list = response[ApiKeys.data];
        if (list != null) {
          return list.map((product) => ProductModel.fromJson(product)).toList();
        }
      }
      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw UnKnownException();
    }
  }
}

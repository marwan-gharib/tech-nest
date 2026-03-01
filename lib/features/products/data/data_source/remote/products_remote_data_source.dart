import 'dart:developer';

import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/params/products_params.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/features/products/data/models/product_model.dart';

class ProductsRemoteDataSource {
  final ApiConsumer _api;

  ProductsRemoteDataSource(this._api);

  Future<List<ProductModel>> getProducts({
    required ProductsParams params,
  }) async {
    try {
      final response = await _api.get(
        Endpoints.productsList,
        queryParameters: params.toJson(),
      );

      if (response != null) {
        final List? list = response[ApiKeys.data][ApiKeys.products];
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

  Future<List<String>> searchSuggestions(String searchQuery) async {
    try {
      final response = await _api.get(
        Endpoints.searchingSuggestions,
        queryParameters: {ApiKeys.searchQuery: searchQuery},
      );

      if (response != null) {
        (response[ApiKeys.data] as List).map(
          (e) => log(e.runtimeType.toString()),
        );
        final List? list = response[ApiKeys.data];
        if (list != null) {
          return list.map((e) => e.toString()).toList();
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

import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';

class CategoriesRemoteDataSource {
  final ApiConsumer _api;

  CategoriesRemoteDataSource(this._api);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _api.get(Endpoints.categoriesList);

      if (response != null) {
        final List? list = response[ApiKeys.data];
        if (list != null) {
          return list
              .map((product) => CategoryModel.fromJson(product))
              .toList();
        }
      }
      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }
}

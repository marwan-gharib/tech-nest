import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';

class SearchSuggestionsUsecase {
  final ProductsRepository _repo;

  SearchSuggestionsUsecase(this._repo);

  Future<ApiResult<List<String>>> call({
    required String searchQuery,
  }) async {
    return await _repo.searchSuggestions(searchQuery: searchQuery);
  }
}

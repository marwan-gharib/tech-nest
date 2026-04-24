import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/repositories/products_shared_repository.dart';

class SearchSuggestionsUsecase {
  final ProductsSharedRepository _repo;

  SearchSuggestionsUsecase(this._repo);

  Future<Either<Failure, List<String>>> call({
    required String searchQuery,
  }) async {
    return await _repo.searchSuggestions(searchQuery: searchQuery);
  }
}

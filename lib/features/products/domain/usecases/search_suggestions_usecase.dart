import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';

class SearchSuggestionsUsecase {
  final ProductsRepository _repo;

  SearchSuggestionsUsecase(this._repo);

  Future<Either<Failure, List<String>>> call({
    required String searchQuery,
  }) async {
    return await _repo.searchSuggestions(searchQuery: searchQuery);
  }
}

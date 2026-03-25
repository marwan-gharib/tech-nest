import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';

class SearchSuggestionsUsecase {
  final ProductsRepo _repo;

  SearchSuggestionsUsecase(this._repo);

  Future<Either<Failure, List<String>>> call({
    required String searchQuery,
  }) async {
    try {
      return Right(await _repo.searchSuggestions(searchQuery: searchQuery));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

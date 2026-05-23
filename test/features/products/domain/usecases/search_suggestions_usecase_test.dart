import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';
import 'package:tech_nest/features/products/domain/usecases/search_suggestions_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late SearchSuggestionsUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = SearchSuggestionsUsecase(mockRepository);
  });

  const tQuery = 'laptop';
  final tSuggestionsList = ['laptop gaming', 'laptop stand'];

  test('should get search suggestions from the repository', () async {
    when(() => mockRepository.searchSuggestions(searchQuery: tQuery))
        .thenAnswer((_) async => Right(tSuggestionsList));

    final result = await usecase(searchQuery: tQuery);

    expect(result, equals(Right(tSuggestionsList)));
    verify(() => mockRepository.searchSuggestions(searchQuery: tQuery)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(() => mockRepository.searchSuggestions(searchQuery: tQuery))
        .thenAnswer((_) async => Left<Failure, List<String>>(ServerFailure()));

    final result = await usecase(searchQuery: tQuery);

    result.fold(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('Should not return success'),
    );
    verify(() => mockRepository.searchSuggestions(searchQuery: tQuery)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/products/domain/usecases/search_suggestions_usecase.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';

class MockSearchSuggestionsUsecase extends Mock
    implements SearchSuggestionsUsecase {}

void main() {
  late SearchSuggestionsCubit cubit;
  late MockSearchSuggestionsUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockSearchSuggestionsUsecase();
    cubit = SearchSuggestionsCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  const tQuery = 'test';
  final tSuggestions = ['test1', 'test2'];

  group('SearchSuggestionsCubit', () {
    test('initial state should be SearchSuggestionsInitial', () {
      expect(cubit.state, equals(const SearchSuggestionsInitial()));
    });

    blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
      'should emit [Initial] when query is empty',
      build: () => cubit,
      act: (cubit) => cubit.getSuggestions(searchLabel: ''),
      expect: () => [isA<SearchSuggestionsInitial>()],
      verify: (_) {
        verifyNever(
          () => mockUsecase.call(searchQuery: any(named: 'searchQuery')),
        );
      },
    );

    blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
      'should emit [Loading, Loaded] when usecase is successful',
      build: () {
        when(
          () => mockUsecase.call(searchQuery: tQuery),
        ).thenAnswer((_) async => ApiSuccess(tSuggestions));
        return cubit;
      },
      act: (cubit) => cubit.getSuggestions(searchLabel: tQuery),
      wait: const Duration(milliseconds: 450),
      expect: () => [
         isA<SearchSuggestionsLoading>(),
        isA<SearchSuggestionsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockUsecase.call(searchQuery: tQuery)).called(1);
      },
    );

    blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
      'should emit [Loading, Empty] when usecase returns empty list',
      build: () {
        when(
          () => mockUsecase.call(searchQuery: tQuery),
        ).thenAnswer((_) async => const ApiSuccess([]));
        return cubit;
      },
      act: (cubit) => cubit.getSuggestions(searchLabel: tQuery),
      wait: const Duration(milliseconds: 450),
      expect: () => [
        isA<SearchSuggestionsLoading>(),
        isA<SearchSuggestionsEmpty>(),
      ],
    );

    final tServerFailure = ServerFailure();

    blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
      'should emit [Loading, Failed] when usecase fails',
      build: () {
        when(
          () => mockUsecase.call(searchQuery: tQuery),
        ).thenAnswer((_) async => ApiFailure(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.getSuggestions(searchLabel: tQuery),
      wait: const Duration(milliseconds: 450),
      expect: () => [
        isA<SearchSuggestionsLoading>(),
        isA<SearchSuggestionsFailed>(),
      ],
    );

    test(
      'should cache results and emit immediately without calling usecase',
      () async {
        when(
          () => mockUsecase.call(searchQuery: tQuery),
        ).thenAnswer((_) async => ApiSuccess(tSuggestions));

        // First call
        cubit.getSuggestions(searchLabel: tQuery);
        await Future.delayed(const Duration(milliseconds: 500));
        expect(
          cubit.state,
          equals(SearchSuggestionsLoaded(suggestions: tSuggestions)),
        );

        // Clear interactions to check if called again
        clearInteractions(mockUsecase);

        // Second call (should be from cache)
        cubit.getSuggestions(searchLabel: tQuery);
        expect(
          cubit.state,
          equals(SearchSuggestionsLoaded(suggestions: tSuggestions)),
        );

        verifyNever(
          () => mockUsecase.call(searchQuery: any(named: 'searchQuery')),
        );
      },
    );

    blocTest<SearchSuggestionsCubit, SearchSuggestionsState>(
      'should clear cache and emit Initial',
      build: () => cubit,
      act: (cubit) => cubit.clearCache(),
      expect: () => [const SearchSuggestionsInitial()],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/categories/domain/usecases/fetch_categories_usecase.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';

class MockFetchCategoriesUsecase extends Mock implements FetchCategoriesUsecase {}

void main() {
  late FetchCategoriesCubit cubit;
  late MockFetchCategoriesUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockFetchCategoriesUsecase();
    cubit = FetchCategoriesCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  group('FetchCategoriesCubit', () {
    const tCategoryList = [
      CategoryEntity(id: 1, name: 'Electronics', imgUrl: 'test.png'),
    ];
    final tFailure = ServerFailure(message: 'Server Error');

    test('initial state should be FetchCategoriesInitial', () {
      expect(cubit.state, equals(const FetchCategoriesInitial()));
    });

    blocTest<FetchCategoriesCubit, FetchCategoriesState>(
      'should emit [FetchCategoriesLoading, FetchCategoriesLoaded] when fetching categories is successful',
      build: () {
        when(() => mockUsecase.call())
            .thenAnswer((_) async => const Right(tCategoryList));
        return cubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        const FetchCategoriesLoading(),
        const FetchCategoriesLoaded(categories: tCategoryList),
      ],
      verify: (_) {
        verify(() => mockUsecase.call()).called(1);
      },
    );

    blocTest<FetchCategoriesCubit, FetchCategoriesState>(
      'should emit [FetchCategoriesLoading, FetchCategoriesFailed] when fetching categories fails',
      build: () {
        when(() => mockUsecase.call())
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        const FetchCategoriesLoading(),
        FetchCategoriesFailed(failure: tFailure),
      ],
      verify: (_) {
        verify(() => mockUsecase.call()).called(1);
      },
    );
  });
}

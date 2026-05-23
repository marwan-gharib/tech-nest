import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/usecases/get_products_usecase.dart';

class MockGetProductsUsecase extends Mock implements GetProductsUsecase {}

class FakeProductsParams extends Fake implements ProductsParams {}

void main() {
  late CategoryProductsCubit cubit;
  late MockGetProductsUsecase mockUsecase;

  setUpAll(() {
    registerFallbackValue(FakeProductsParams());
  });

  setUp(() {
    mockUsecase = MockGetProductsUsecase();
    cubit = CategoryProductsCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  group('CategoryProductsCubit', () {
    const tProductList = [
      ProductEntity.empty(),
    ];
    final tFailure = ServerFailure(message: 'Server Error');

    test('initial state should be CategoryProductsInitial', () {
      expect(cubit.state, equals(const CategoryProductsInitial()));
    });

    blocTest<CategoryProductsCubit, CategoryProductsState>(
      'should emit [CategoryProductsLoading, CategoryProductsLoaded] when fetching initial category products is successful',
      build: () {
        when(() => mockUsecase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const Right(tProductList));
        return cubit;
      },
      act: (cubit) => cubit.fetchInitialCategoryProducts(categoryId: 1),
      expect: () => [
        const CategoryProductsLoading(),
        const CategoryProductsLoaded(
          products: tProductList,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verify(() => mockUsecase.call(params: any(named: 'params'))).called(1);
      },
    );

    blocTest<CategoryProductsCubit, CategoryProductsState>(
      'should emit [CategoryProductsLoading, CategoryProductsError] when fetching initial category products fails',
      build: () {
        when(() => mockUsecase.call(params: any(named: 'params')))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.fetchInitialCategoryProducts(categoryId: 1),
      expect: () => [
        const CategoryProductsLoading(),
        CategoryProductsError(tFailure),
      ],
    );

    blocTest<CategoryProductsCubit, CategoryProductsState>(
      'should emit loaded state with more products when fetchMoreCategoryProducts is successful',
      build: () {
        when(() => mockUsecase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const Right(tProductList));
        return cubit;
      },
      seed: () => const CategoryProductsLoaded(
        products: tProductList,
        hasReachedMax: false,
      ),
      act: (cubit) => cubit.fetchMoreCategoryProducts(),
      expect: () => [
        const CategoryProductsLoaded(
          products: tProductList,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        const CategoryProductsLoaded(
          products: [...tProductList, ...tProductList],
          hasReachedMax: true,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<CategoryProductsCubit, CategoryProductsState>(
      'should emit loaded state with loadMoreFailure when fetchMoreCategoryProducts fails',
      build: () {
        when(() => mockUsecase.call(params: any(named: 'params')))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      seed: () => const CategoryProductsLoaded(
        products: tProductList,
        hasReachedMax: false,
      ),
      act: (cubit) => cubit.fetchMoreCategoryProducts(),
      expect: () => [
        const CategoryProductsLoaded(
          products: tProductList,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        CategoryProductsLoaded(
          products: tProductList,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: tFailure,
        ),
      ],
    );

    blocTest<CategoryProductsCubit, CategoryProductsState>(
      'should not fetch more products if hasReachedMax is true',
      build: () {
        return cubit;
      },
      seed: () => const CategoryProductsLoaded(
        products: tProductList,
        hasReachedMax: true,
      ),
      act: (cubit) => cubit.fetchMoreCategoryProducts(),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockUsecase.call(params: any(named: 'params')));
      },
    );

    blocTest<CategoryProductsCubit, CategoryProductsState>(
      'should re-fetch initial products when retryInitialCategoryProducts is called and last category id is set',
      build: () {
        when(() => mockUsecase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const Right(tProductList));
        return cubit;
      },
      seed: () => CategoryProductsError(tFailure),
      act: (cubit) async {
        await cubit.fetchInitialCategoryProducts(categoryId: 1);
        cubit.retryInitialCategoryProducts();
      },
      skip: 2, // Skip the emissions from fetchInitialCategoryProducts
      expect: () => [
        const CategoryProductsLoading(),
        const CategoryProductsLoaded(
          products: tProductList,
          hasReachedMax: true,
        ),
      ],
    );
  });
}

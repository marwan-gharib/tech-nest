import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/usecases/get_products_usecase.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';

class MockGetProductsUsecase extends Mock implements GetProductsUsecase {}

class FakeProductsParams extends Fake implements ProductsParams {}

void main() {
  late FetchProductsCubit cubit;
  late MockGetProductsUsecase mockUsecase;

  setUpAll(() {
    registerFallbackValue(FakeProductsParams());
  });

  setUp(() {
    mockUsecase = MockGetProductsUsecase();
    cubit = FetchProductsCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  final tProductList = [const ProductEntity.empty()];

  group('FetchProductsCubit', () {
    test('initial state should be FetchProductsInitial', () {
      expect(cubit.state, equals(const FetchProductsInitial()));
    });

    blocTest<FetchProductsCubit, FetchProductsState>(
      'should emit [Loading, Loaded] when initialFetching is successful',
      build: () {
        when(
          () => mockUsecase.call(params: any(named: 'params')),
        ).thenAnswer((_) async => Right(tProductList));
        return cubit;
      },
      act: (cubit) => cubit.initialFetching(),
      expect: () => [
        isA<FetchProductsLoading>(),
        isA<FetchProductsLoaded>(),
      ],
    );

    blocTest<FetchProductsCubit, FetchProductsState>(
      'should emit [Loading, Error] when initialFetching fails',
      build: () {
        when(
          () => mockUsecase.call(params: any(named: 'params')),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.initialFetching(),
      expect: () => [
        isA<FetchProductsLoading>(),
        isA<FetchProductsError>(),
      ],
    );

    blocTest<FetchProductsCubit, FetchProductsState>(
      'should handle fetchMore correctly when successful',
      seed: () => FetchProductsLoaded(
        products: tProductList,
        hasReachedMax: false,
        isSearchApplied: false,
        isFilterApplied: false,
      ),
      build: () {
        when(
          () => mockUsecase.call(params: any(named: 'params')),
        ).thenAnswer((_) async => Right(tProductList));
        return cubit;
      },
      act: (cubit) => cubit.fetchMore(),
      expect: () => [
        isA<FetchProductsLoaded>(),
        isA<FetchProductsLoaded>(),
      ],
    );

    blocTest<FetchProductsCubit, FetchProductsState>(
      'should handle fetchMore error correctly',
      seed: () => FetchProductsLoaded(
        products: tProductList,
        hasReachedMax: false,
        isSearchApplied: false,
        isFilterApplied: false,
      ),
      build: () {
        when(
          () => mockUsecase.call(params: any(named: 'params')),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.fetchMore(),
      expect: () => [
        isA<FetchProductsLoaded>(),
        isA<FetchProductsLoaded>(),
      ],
    );

    blocTest<FetchProductsCubit, FetchProductsState>(
      'should emit [Loading, Loaded] when search is called',
      build: () {
        when(
          () => mockUsecase.call(params: any(named: 'params')),
        ).thenAnswer((_) async => Right(tProductList));
        return cubit;
      },
      act: (cubit) => cubit.search('test'),
      expect: () => [
        isA<FetchProductsLoading>(),
        isA<FetchProductsLoaded>(),
      ],
    );
  });
}

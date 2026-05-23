import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';
import 'package:tech_nest/features/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/data/models/product_model.dart';
import 'package:tech_nest/features/products/data/repositories/products_repository_impl.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';

class MockProductsRemoteDatasource extends Mock
    implements ProductsRemoteDatasource {}

void main() {
  late ProductsRepositoryImpl repository;
  late MockProductsRemoteDatasource mockDataSource;

  setUp(() {
    mockDataSource = MockProductsRemoteDatasource();
    repository = ProductsRepositoryImpl(mockDataSource);
  });

  final tCategoryModel = CategoryModel(
    id: 1,
    name: 'Test Category',
    imgUrl: 'test.jpg',
  );

  final tProductModel = ProductModel(
    id: 1,
    name: 'Test Product',
    description: 'Test Description',
    price: 100.0,
    stock: 10,
    category: tCategoryModel,
    imgUrl: 'test_image.png',
  );

  final tProductsParams = ProductsParams(limit: 10, page: 1);

  group('getProducts', () {
    test(
      'should return List<ProductEntity> when data source is successful',
      () async {
        when(
          () => mockDataSource.getProducts(params: tProductsParams),
        ).thenAnswer((_) async => [tProductModel]);

        final result = await repository.getProducts(params: tProductsParams);

        expect(result, isA<Right<Failure, List<ProductEntity>>>());
        result.fold((l) => fail('Should not return failure'), (r) {
          expect(r.length, 1);
          expect(r.first, equals(tProductModel.toEntity()));
        });
        verify(
          () => mockDataSource.getProducts(params: tProductsParams),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return ServerFailure when data source throws AppException',
      () async {
        when(
          () => mockDataSource.getProducts(params: tProductsParams),
        ).thenThrow(ServerException(""));

        final result = await repository.getProducts(params: tProductsParams);

        expect(result, isA<Left<Failure, List<ProductEntity>>>());
        result.fold(
          (l) => expect(l, isA<ServerFailure>()),
          (r) => fail('Should not return success'),
        );
      },
    );

    test(
      'should return UnknownFailure when data source throws unexpected Exception',
      () async {
        when(
          () => mockDataSource.getProducts(params: tProductsParams),
        ).thenThrow(Exception());

        final result = await repository.getProducts(params: tProductsParams);

        expect(result, isA<Left<Failure, List<ProductEntity>>>());
        result.fold(
          (l) => expect(l, isA<UnknownFailure>()),
          (r) => fail('Should not return success'),
        );
      },
    );
  });

  group('getProduct', () {
    const tProductId = 1;

    test(
      'should return ProductEntity when data source is successful',
      () async {
        when(
          () => mockDataSource.getProduct(productId: tProductId),
        ).thenAnswer((_) async => tProductModel);

        final result = await repository.getProduct(productId: tProductId);

        expect(result, isA<Right<Failure, ProductEntity>>());
        result.fold(
          (l) => fail('Should not return failure'),
          (r) => expect(r, equals(tProductModel.toEntity())),
        );
        verify(
          () => mockDataSource.getProduct(productId: tProductId),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return ServerFailure when data source throws AppException',
      () async {
        when(
          () => mockDataSource.getProduct(productId: tProductId),
        ).thenThrow(ServerException(""));

        final result = await repository.getProduct(productId: tProductId);

        expect(result, isA<Left<Failure, ProductEntity>>());
        result.fold(
          (l) => expect(l, isA<ServerFailure>()),
          (r) => fail('Should not return success'),
        );
      },
    );
  });

  group('searchSuggestions', () {
    const tQuery = 'test';
    final tSuggestions = ['test1', 'test2'];

    test('should return List<String> when data source is successful', () async {
      when(
        () => mockDataSource.searchSuggestions(tQuery),
      ).thenAnswer((_) async => tSuggestions);

      final result = await repository.searchSuggestions(searchQuery: tQuery);

      expect(result, isA<Right<Failure, List<String>>>());
      result.fold(
        (l) => fail('Should not return failure'),
        (r) => expect(r, equals(tSuggestions)),
      );
      verify(() => mockDataSource.searchSuggestions(tQuery)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test(
      'should return ServerFailure when data source throws AppException',
      () async {
        when(
          () => mockDataSource.searchSuggestions(tQuery),
        ).thenThrow(ServerException(""));

        final result = await repository.searchSuggestions(searchQuery: tQuery);

        expect(result, isA<Left<Failure, List<String>>>());
      },
    );
  });
}

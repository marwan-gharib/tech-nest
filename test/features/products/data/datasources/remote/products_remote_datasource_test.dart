import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/data/models/product_model.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late ProductsRemoteDatasource datasource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = ProductsRemoteDatasource(mockApiClient);
  });

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  const tProductJson = {
    'id': 1,
    'name': 'Test Product',
    'description': 'A test product',
    'price': 99.99,
    'stock': 10,
    'category': {'id': 1, 'name': 'Electronics', 'image_url': 'cat.png'},
    'image_url': 'product.png',
  };

  final tParams = ProductsParams();

  group('getProducts', () {
    final tValidResponse = {
      'data': {
        'products': [tProductJson],
      },
    };

    test(
      'should return List<ProductModel> when response contains valid data',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tValidResponse);

        final result = await datasource.getProducts(params: tParams);

        expect(result, isA<List<ProductModel>>());
        expect(result.length, 1);
        expect(result.first.name, 'Test Product');
        verify(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.getProducts(params: tParams),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'should throw UnKnownException when products list inside response is null',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => {
            'data': {'products': null},
          },
        );

        expect(
          () => datasource.getProducts(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.getProducts(params: tParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.getProducts(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('getProduct', () {
    const tProductId = 1;

    final tValidResponse = {
      'data': {'product': tProductJson},
    };

    test(
      'should return ProductModel when response contains valid data',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tValidResponse);

        final result = await datasource.getProduct(productId: tProductId);

        expect(result, isA<ProductModel>());
        expect(result.id, 1);
        expect(result.name, 'Test Product');
      },
    );

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.getProduct(productId: tProductId),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'should throw UnKnownException when product data inside response is null',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => {
            'data': {'product': null},
          },
        );

        expect(
          () => datasource.getProduct(productId: tProductId),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.getProduct(productId: tProductId),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.getProduct(productId: tProductId),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('searchSuggestions', () {
    const tQuery = 'laptop';

    final tValidResponse = {
      'data': ['laptop pro', 'laptop air'],
    };

    test(
      'should return List<String> when response contains valid data',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tValidResponse);

        final result = await datasource.searchSuggestions(tQuery);

        expect(result, isA<List<String>>());
        expect(result.length, 2);
        expect(result.first, 'laptop pro');
      },
    );

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.searchSuggestions(tQuery),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'should throw UnKnownException when data list inside response is null',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => {'data': null});

        expect(
          () => datasource.searchSuggestions(tQuery),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.searchSuggestions(tQuery),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.searchSuggestions(tQuery),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });
}

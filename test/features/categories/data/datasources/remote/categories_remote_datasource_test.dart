import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/categories/data/datasources/remote/categories_remote_data_source.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late CategoriesRemoteDatasource datasource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = CategoriesRemoteDatasource(mockApiClient);
  });

  const tCategoryJson = {
    'id': 1,
    'name': 'Electronics',
    'image_url': 'test.png',
  };

  final tValidResponse = {
    'data': [tCategoryJson],
  };

  group('getCategories', () {
    test(
      'should return List<CategoryModel> when response contains valid data',
      () async {
        when(
          () => mockApiClient.get(any()),
        ).thenAnswer((_) async => tValidResponse);

        final result = await datasource.getCategories();

        expect(result, isA<List<CategoryModel>>());
        expect(result.length, 1);
        expect(result.first.name, 'Electronics');
        expect(result.first.id, 1);
        verify(() => mockApiClient.get(any())).called(1);
      },
    );

    test(
      'should throw UnKnownException when response is null',
      () async {
        when(
          () => mockApiClient.get(any()),
        ).thenAnswer((_) async => null);

        expect(
          () => datasource.getCategories(),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when data list inside response is null',
      () async {
        when(
          () => mockApiClient.get(any()),
        ).thenAnswer((_) async => {'data': null});

        expect(
          () => datasource.getCategories(),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.get(any()),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.getCategories(),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.get(any()),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => datasource.getCategories(),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });
}

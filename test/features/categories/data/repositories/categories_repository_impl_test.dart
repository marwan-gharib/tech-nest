import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/features/categories/data/datasources/remote/categories_remote_data_source.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';
import 'package:tech_nest/features/categories/data/repositories/categories_repository_impl.dart';

class MockCategoriesRemoteDatasource extends Mock
    implements CategoriesRemoteDatasource {}

void main() {
  late CategoriesRepositoryImpl repository;
  late MockCategoriesRemoteDatasource mockDataSource;

  setUp(() {
    mockDataSource = MockCategoriesRemoteDatasource();
    repository = CategoriesRepositoryImpl(mockDataSource);
  });

  group('CategoriesRepositoryImpl', () {
    final tCategoryModel = CategoryModel(
      id: 1,
      name: 'Test',
      imgUrl: 'test.jpg',
    );
    final tCategoryModels = [tCategoryModel];
    final tCategoryEntities = [tCategoryModel.toEntity()];

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        when(
          () => mockDataSource.getCategories(),
        ).thenAnswer((_) async => tCategoryModels);

        final result = await repository.getCategories();

        verify(() => mockDataSource.getCategories()).called(1);
        expect(result.fold((l) => l, (r) => r), equals(tCategoryEntities));
      },
    );

    test(
      'should return a ServerFailure when the call to remote data source throws a ServerException',
      () async {
        when(
          () => mockDataSource.getCategories(),
        ).thenThrow(ServerException('Server Error'));

        final result = await repository.getCategories();

        verify(() => mockDataSource.getCategories()).called(1);
        expect(result, isA<ApiFailure>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Should have returned a Failure'),
        );
      },
    );

    test(
      'should return an UnknownFailure when an unexpected exception is thrown',
      () async {
        when(
          () => mockDataSource.getCategories(),
        ).thenThrow(Exception('Unexpected error'));

        final result = await repository.getCategories();

        verify(() => mockDataSource.getCategories()).called(1);
        expect(result.fold((l) => l, (r) => r), isA<UnknownFailure>());
      },
    );
  });
}

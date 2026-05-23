import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';
import 'package:tech_nest/features/products/domain/usecases/get_products_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late GetProductsUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = GetProductsUsecase(mockRepository);
  });

  final tProductsParams = ProductsParams(limit: 10, page: 1);
  final tProductsList = [const ProductEntity.empty()];

  test('should get products from the repository', () async {
    when(() => mockRepository.getProducts(params: tProductsParams))
        .thenAnswer((_) async => Right(tProductsList));

    final result = await usecase(params: tProductsParams);

    expect(result, equals(Right(tProductsList)));
    verify(() => mockRepository.getProducts(params: tProductsParams)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(() => mockRepository.getProducts(params: tProductsParams))
        .thenAnswer((_) async => Left<Failure, List<ProductEntity>>(ServerFailure()));

    final result = await usecase(params: tProductsParams);

    result.fold(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('Should not return success'),
    );
    verify(() => mockRepository.getProducts(params: tProductsParams)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

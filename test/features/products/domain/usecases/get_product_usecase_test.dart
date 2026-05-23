import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';
import 'package:tech_nest/features/products/domain/usecases/get_product_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late GetProductUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = GetProductUsecase(mockRepository);
  });

  const tProductId = 1;
  const tProductEntity = ProductEntity.empty();

  test('should get product from the repository', () async {
    when(() => mockRepository.getProduct(productId: tProductId))
        .thenAnswer((_) async => const Right(tProductEntity));

    final result = await usecase(tProductId);

    expect(result, equals(const Right(tProductEntity)));
    verify(() => mockRepository.getProduct(productId: tProductId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(() => mockRepository.getProduct(productId: tProductId))
        .thenAnswer((_) async => Left<Failure, ProductEntity>(ServerFailure()));

    final result = await usecase(tProductId);

    result.fold(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('Should not return success'),
    );
    verify(() => mockRepository.getProduct(productId: tProductId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

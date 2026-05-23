import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/usecases/get_product_usecase.dart';
import 'package:tech_nest/features/products/presentation/cubits/get_product_cubit/get_product_cubit.dart';

class MockGetProductUsecase extends Mock implements GetProductUsecase {}

void main() {
  late GetProductCubit cubit;
  late MockGetProductUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockGetProductUsecase();
    cubit = GetProductCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  const tProductId = 1;
  const tProductEntity = ProductEntity.empty();

  group('GetProductCubit', () {
    test('initial state should be GetProductInitial', () {
      expect(cubit.state, equals(const GetProductInitial()));
    });

    blocTest<GetProductCubit, GetProductState>(
      'should emit [Loading, Loaded] when getProduct is successful',
      build: () {
        when(() => mockUsecase(tProductId))
            .thenAnswer((_) async => const Right(tProductEntity));
        return cubit;
      },
      act: (cubit) => cubit.getProduct(tProductId),
      expect: () => [
        isA<GetProductLoading>(),
        isA<GetProductLoaded>(),
      ],
      verify: (_) {
        verify(() => mockUsecase(tProductId)).called(1);
      },
    );

    blocTest<GetProductCubit, GetProductState>(
      'should emit [Loading, Error] when getProduct fails',
      build: () {
        when(() => mockUsecase(tProductId))
            .thenAnswer((_) async => Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.getProduct(tProductId),
      expect: () => [
        isA<GetProductLoading>(),
        isA<GetProductError>(),
      ],
      verify: (_) {
        verify(() => mockUsecase(tProductId)).called(1);
      },
    );

    blocTest<GetProductCubit, GetProductState>(
      'should ensure state consistency after multiple consecutive calls',
      build: () {
        when(() => mockUsecase(tProductId))
            .thenAnswer((_) async => const Right(tProductEntity));
        return cubit;
      },
      act: (cubit) async {
        cubit.getProduct(tProductId);
        await Future.delayed(Duration.zero);
        cubit.getProduct(tProductId);
      },
      expect: () => [
        isA<GetProductLoading>(),
        isA<GetProductLoaded>(),
        isA<GetProductLoading>(),
        isA<GetProductLoaded>(),
      ],
    );
  });
}

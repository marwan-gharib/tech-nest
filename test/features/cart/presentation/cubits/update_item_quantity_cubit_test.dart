import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/usecases/update_item_quantity_usecase.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';

class MockUpdateItemQuantityUsecase extends Mock implements UpdateItemQuantityUsecase {}

void main() {
  late UpdateItemQuantityCubit cubit;
  late MockUpdateItemQuantityUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockUpdateItemQuantityUsecase();
    cubit = UpdateItemQuantityCubit(mockUsecase);
    registerFallbackValue(UpdateItemQuantityParams(cartId: 1, quantity: 2));
  });

  tearDown(() {
    cubit.close();
  });

  final tFailure = ServerFailure(message: 'Server Error');

  test('initial state should be UpdateItemQuantityInitial', () {
    expect(cubit.state, const UpdateItemQuantityInitial());
  });

  group('updateQuantity', () {
    blocTest<UpdateItemQuantityCubit, UpdateItemQuantityState>(
      'emits [Loading, Success] when usecase succeeds',
      build: () {
        when(() => mockUsecase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const Right(3));
        return cubit;
      },
      act: (cubit) => cubit.updateQuantity(cartId: 1, updatedQuantity: 3),
      expect: () => [
        const UpdateItemQuantityLoading(),
        const UpdateItemQuantitySuccess(updatedQuantity: 3),
      ],
      verify: (_) => verify(() => mockUsecase.call(params: any(named: 'params'))).called(1),
    );

    blocTest<UpdateItemQuantityCubit, UpdateItemQuantityState>(
      'emits [Loading, Failed] when usecase fails',
      build: () {
        when(() => mockUsecase.call(params: any(named: 'params')))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.updateQuantity(cartId: 1, updatedQuantity: 3),
      expect: () => [
        const UpdateItemQuantityLoading(),
        UpdateItemQuantityFailed(failure: tFailure),
      ],
      verify: (_) => verify(() => mockUsecase.call(params: any(named: 'params'))).called(1),
    );
  });
}

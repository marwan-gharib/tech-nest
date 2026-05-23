import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';

class MockRemoveFromCartUsecase extends Mock implements RemoveFromCartUsecase {}

void main() {
  late DeleteCartItemCubit cubit;
  late MockRemoveFromCartUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockRemoveFromCartUsecase();
    cubit = DeleteCartItemCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  final tFailure = ServerFailure(message: 'Server Error');

  test('initial state should be DeleteCartItemInitial', () {
    expect(cubit.state, const DeleteCartItemInitial());
  });

  group('removeItem', () {
    blocTest<DeleteCartItemCubit, DeleteCartItemState>(
      'emits [Loading, Success] when usecase succeeds',
      build: () {
        when(() => mockUsecase.call(cartId: 1))
            .thenAnswer((_) async => const Right(1));
        return cubit;
      },
      act: (cubit) => cubit.removeItem(cartId: 1),
      expect: () => [
        const DeleteCartItemLoading(),
        const DeleteCartItemSuccess(id: 1),
      ],
      verify: (_) => verify(() => mockUsecase.call(cartId: 1)).called(1),
    );

    blocTest<DeleteCartItemCubit, DeleteCartItemState>(
      'emits [Loading, Failed] when usecase fails',
      build: () {
        when(() => mockUsecase.call(cartId: 1))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.removeItem(cartId: 1),
      expect: () => [
        const DeleteCartItemLoading(),
        DeleteCartItemFailed(failure: tFailure),
      ],
      verify: (_) => verify(() => mockUsecase.call(cartId: 1)).called(1),
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_state.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';

class MockCreateOrderUseCase extends Mock implements CreateOrderUseCase {}

void main() {
  late CreateOrderCubit cubit;
  late MockCreateOrderUseCase mockCreateOrderUseCase;

  const tParams = CreateOrderParams(
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
  );

  final tFailure = ServerFailure(message: 'Create order failed');

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    cubit = CreateOrderCubit(mockCreateOrderUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is CreateOrderInitial', () {
    expect(cubit.state, const CreateOrderInitial());
  });

  group('createOrder', () {
    blocTest<CreateOrderCubit, CreateOrderState>(
      'emits Loading then Success when use case succeeds',
      build: () {
        when(
          () => mockCreateOrderUseCase.call(params: tParams),
        ).thenAnswer((_) async => const ApiSuccess(7));
        return cubit;
      },
      act: (cubit) => cubit.createOrder(tParams),
      expect: () => [const CreateOrderLoading(), const CreateOrderSuccess(7)],
      verify: (_) =>
          verify(() => mockCreateOrderUseCase.call(params: tParams)).called(1),
    );

    blocTest<CreateOrderCubit, CreateOrderState>(
      'emits Loading then Failed when use case fails',
      build: () {
        when(
          () => mockCreateOrderUseCase.call(params: tParams),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.createOrder(tParams),
      expect: () => [const CreateOrderLoading(), CreateOrderFailed(tFailure)],
      verify: (_) =>
          verify(() => mockCreateOrderUseCase.call(params: tParams)).called(1),
    );

    blocTest<CreateOrderCubit, CreateOrderState>(
      'keeps state consistent after repeated successful calls',
      build: () {
        int calls = 0;
        when(() => mockCreateOrderUseCase.call(params: tParams)).thenAnswer((
          _,
        ) async {
          calls += 1;
          return ApiSuccess(calls);
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.createOrder(tParams);
        await cubit.createOrder(tParams);
      },
      expect: () => [
        const CreateOrderLoading(),
        const CreateOrderSuccess(1),
        const CreateOrderLoading(),
        const CreateOrderSuccess(2),
      ],
      verify: (_) =>
          verify(() => mockCreateOrderUseCase.call(params: tParams)).called(2),
    );

    blocTest<CreateOrderCubit, CreateOrderState>(
      'handles rapid calls while preserving the final success state',
      build: () {
        when(
          () => mockCreateOrderUseCase.call(params: tParams),
        ).thenAnswer((_) async => const ApiSuccess(7));
        return cubit;
      },
      act: (cubit) async {
        await Future.wait([
          cubit.createOrder(tParams),
          cubit.createOrder(tParams),
        ]);
      },
      expect: () => [const CreateOrderLoading(), const CreateOrderSuccess(7)],
      verify: (_) =>
          verify(() => mockCreateOrderUseCase.call(params: tParams)).called(2),
    );
  });
}

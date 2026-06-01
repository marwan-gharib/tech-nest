import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_state.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';

class MockCreateOrderUseCase extends Mock implements CreateOrderUseCase {}

void main() {
  late MockCreateOrderUseCase mockCreateOrderUseCase;
  late CreateOrderCubit cubit;

  const params = CreateOrderParams(
    shippingAddress: 'Cairo',
    billingAddress: 'Cairo',
  );

  final serverFailure = ServerFailure(message: 'Server failed');
  final networkFailure = NetworkFailure();

  setUpAll(() {
    registerFallbackValue(params);
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

  blocTest<CreateOrderCubit, CreateOrderState>(
    'emits loading then success when use case returns order id',
    build: () {
      when(
        () => mockCreateOrderUseCase.call(params: params),
      ).thenAnswer((_) async => const Right(12));
      return cubit;
    },
    act: (cubit) => cubit.createOrder(params),
    expect: () => [const CreateOrderLoading(), const CreateOrderSuccess(12)],
    verify: (_) {
      verify(() => mockCreateOrderUseCase.call(params: params)).called(1);
    },
  );

  blocTest<CreateOrderCubit, CreateOrderState>(
    'emits loading then failed when use case returns server failure',
    build: () {
      when(
        () => mockCreateOrderUseCase.call(params: params),
      ).thenAnswer((_) async => Left(serverFailure));
      return cubit;
    },
    act: (cubit) => cubit.createOrder(params),
    expect: () => [
      const CreateOrderLoading(),
      CreateOrderFailed(serverFailure),
    ],
  );

  blocTest<CreateOrderCubit, CreateOrderState>(
    'emits loading then failed when use case returns network failure',
    build: () {
      when(
        () => mockCreateOrderUseCase.call(params: params),
      ).thenAnswer((_) async => Left(networkFailure));
      return cubit;
    },
    act: (cubit) => cubit.createOrder(params),
    expect: () => [
      const CreateOrderLoading(),
      CreateOrderFailed(networkFailure),
    ],
  );

  blocTest<CreateOrderCubit, CreateOrderState>(
    'keeps consistent transitions after repeated sequential calls',
    build: () {
      var calls = 0;
      when(() => mockCreateOrderUseCase.call(params: params)).thenAnswer((
        _,
      ) async {
        calls += 1;
        return Right(calls);
      });
      return cubit;
    },
    act: (cubit) async {
      await cubit.createOrder(params);
      await cubit.createOrder(params);
    },
    expect: () => [
      const CreateOrderLoading(),
      const CreateOrderSuccess(1),
      const CreateOrderLoading(),
      const CreateOrderSuccess(2),
    ],
    verify: (_) {
      verify(() => mockCreateOrderUseCase.call(params: params)).called(2);
    },
  );

  test('rethrows when use case throws unexpected exception', () async {
    when(
      () => mockCreateOrderUseCase.call(params: params),
    ).thenThrow(Exception('unexpected'));

    await expectLater(cubit.createOrder(params), throwsException);
    expect(cubit.state, const CreateOrderLoading());
    verify(() => mockCreateOrderUseCase.call(params: params)).called(1);
  });
}

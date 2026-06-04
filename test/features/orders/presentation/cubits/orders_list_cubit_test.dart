import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/domain/usecases/get_user_orders_usecase.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_state.dart';

class MockGetUserOrdersUseCase extends Mock implements GetUserOrdersUseCase {}

void main() {
  late OrdersListCubit cubit;
  late MockGetUserOrdersUseCase mockGetUserOrdersUseCase;

  const tOrders = [
    OrderEntity(
      id: 7,
      totalPrice: 349.99,
      status: OrderStatus.pending,
      createdAt: '2026-05-20T10:00:00Z',
      updatedAt: '2026-05-21T10:00:00Z',
    ),
    OrderEntity(
      id: 8,
      totalPrice: 120,
      status: OrderStatus.confirmed,
      createdAt: '2026-05-22T10:00:00Z',
      updatedAt: '2026-05-23T10:00:00Z',
    ),
  ];

  final tFailure = ServerFailure(message: 'Orders failed');

  setUp(() {
    mockGetUserOrdersUseCase = MockGetUserOrdersUseCase();
    cubit = OrdersListCubit(mockGetUserOrdersUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is OrdersListInitial', () {
    expect(cubit.state, const OrdersListInitial());
  });

  group('fetchOrders', () {
    blocTest<OrdersListCubit, OrdersListState>(
      'emits Loading then Loaded when use case succeeds',
      build: () {
        when(
          () => mockGetUserOrdersUseCase.call(),
        ).thenAnswer((_) async => const ApiSuccess(tOrders));
        return cubit;
      },
      act: (cubit) => cubit.fetchOrders(),
      expect: () => [
        const OrdersListLoading(),
        const OrdersListLoaded(tOrders),
      ],
      verify: (_) => verify(() => mockGetUserOrdersUseCase.call()).called(1),
    );

    blocTest<OrdersListCubit, OrdersListState>(
      'emits Loaded without Loading when showLoading is false',
      build: () {
        when(
          () => mockGetUserOrdersUseCase.call(),
        ).thenAnswer((_) async => const ApiSuccess(tOrders));
        return cubit;
      },
      act: (cubit) => cubit.fetchOrders(showLoading: false),
      expect: () => [const OrdersListLoaded(tOrders)],
      verify: (_) => verify(() => mockGetUserOrdersUseCase.call()).called(1),
    );

    blocTest<OrdersListCubit, OrdersListState>(
      'emits Loading then Failed when use case fails',
      build: () {
        when(
          () => mockGetUserOrdersUseCase.call(),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.fetchOrders(),
      expect: () => [const OrdersListLoading(), OrdersListFailed(tFailure)],
      verify: (_) => verify(() => mockGetUserOrdersUseCase.call()).called(1),
    );

    blocTest<OrdersListCubit, OrdersListState>(
      'keeps state consistent after repeated calls',
      build: () {
        var calls = 0;
        when(() => mockGetUserOrdersUseCase.call()).thenAnswer((_) async {
          calls += 1;
          if (calls == 1) {
            return ApiSuccess([tOrders.first]);
          }
          return const ApiSuccess(tOrders);
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchOrders();
        await cubit.fetchOrders();
      },
      expect: () => [
        const OrdersListLoading(),
        OrdersListLoaded([tOrders.first]),
        const OrdersListLoading(),
        const OrdersListLoaded(tOrders),
      ],
      verify: (_) => verify(() => mockGetUserOrdersUseCase.call()).called(2),
    );

    blocTest<OrdersListCubit, OrdersListState>(
      'handles rapid consecutive calls without losing the final loaded state',
      build: () {
        when(
          () => mockGetUserOrdersUseCase.call(),
        ).thenAnswer((_) async => const ApiSuccess(tOrders));
        return cubit;
      },
      act: (cubit) async {
        await Future.wait([cubit.fetchOrders(), cubit.fetchOrders()]);
      },
      expect: () => [
        const OrdersListLoading(),
        const OrdersListLoaded(tOrders),
      ],
      verify: (_) => verify(() => mockGetUserOrdersUseCase.call()).called(2),
    );
  });

  group('updateOrderStatusLocally', () {
    blocTest<OrdersListCubit, OrdersListState>(
      'updates only the matching order status when current state is loaded',
      build: () => cubit,
      seed: () => const OrdersListLoaded(tOrders),
      act: (cubit) => cubit.updateOrderStatusLocally(7, OrderStatus.cancelled),
      expect: () => [
        isA<OrdersListLoaded>()
            .having(
              (state) => state.orders.first.status,
              'first order status',
              OrderStatus.cancelled,
            )
            .having(
              (state) => state.orders.last.status,
              'last order status',
              OrderStatus.confirmed,
            ),
      ],
    );

    blocTest<OrdersListCubit, OrdersListState>(
      'does not emit when current state is not loaded',
      build: () => cubit,
      act: (cubit) => cubit.updateOrderStatusLocally(7, OrderStatus.cancelled),
      expect: () => <OrdersListState>[],
    );

    blocTest<OrdersListCubit, OrdersListState>(
      'does not emit when order id does not exist because orders are unchanged',
      build: () => cubit,
      seed: () => const OrdersListLoaded(tOrders),
      act: (cubit) =>
          cubit.updateOrderStatusLocally(3, OrderStatus.cancelled),
      expect: () => <OrdersListState>[],
    );
  });
}

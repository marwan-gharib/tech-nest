import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_item_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:tech_nest/features/orders/domain/usecases/get_order_details_usecase.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';

class MockGetOrderDetailsUseCase extends Mock
    implements GetOrderDetailsUseCase {}

class MockCancelOrderUseCase extends Mock implements CancelOrderUseCase {}

class MockOrdersListCubit extends Mock implements OrdersListCubit {}

void main() {
  late OrderDetailsCubit cubit;
  late MockGetOrderDetailsUseCase mockGetOrderDetailsUseCase;
  late MockCancelOrderUseCase mockCancelOrderUseCase;
  late MockOrdersListCubit mockOrdersListCubit;

  const tOrder = OrderDetailsEntity(
    id: 7,
    totalPrice: 349.99,
    status: OrderStatus.pending,
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
    createdAt: '2026-05-20T10:00:00Z',
    updatedAt: '2026-05-21T10:00:00Z',
    items: [
      OrderItemEntity(
        orderItemId: 1,
        quantity: 2,
        price: 149.50,
        productId: 10,
        name: 'Mechanical Keyboard',
        imageUrl: 'keyboard.png',
      ),
    ],
  );

  final tFailure = ServerFailure(message: 'Order details failed');

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  setUp(() {
    mockGetOrderDetailsUseCase = MockGetOrderDetailsUseCase();
    mockCancelOrderUseCase = MockCancelOrderUseCase();
    mockOrdersListCubit = MockOrdersListCubit();
    cubit = OrderDetailsCubit(
      mockGetOrderDetailsUseCase,
      mockCancelOrderUseCase,
      mockOrdersListCubit,
    );
    when(
      () => mockOrdersListCubit.updateOrderStatusLocally(any(), any()),
    ).thenReturn(null);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is OrderDetailsInitial', () {
    expect(cubit.state, const OrderDetailsInitial());
  });

  group('fetchOrderDetails', () {
    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'emits Loading then Loaded when use case succeeds',
      build: () {
        when(
          () => mockGetOrderDetailsUseCase.call(orderId: 7),
        ).thenAnswer((_) async => const ApiSuccess(tOrder));
        return cubit;
      },
      act: (cubit) => cubit.fetchOrderDetails(7),
      expect: () => [
        const OrderDetailsLoading(),
        const OrderDetailsLoaded(order: tOrder),
      ],
      verify: (_) =>
          verify(() => mockGetOrderDetailsUseCase.call(orderId: 7)).called(1),
    );

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'emits Loading then Failed when use case fails',
      build: () {
        when(
          () => mockGetOrderDetailsUseCase.call(orderId: 7),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.fetchOrderDetails(7),
      expect: () => [const OrderDetailsLoading(), OrderDetailsFailed(tFailure)],
      verify: (_) =>
          verify(() => mockGetOrderDetailsUseCase.call(orderId: 7)).called(1),
    );
  });

  group('cancelOrder', () {
    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'does not invoke cancel use case when current state is not loaded',
      build: () => cubit,
      act: (cubit) => cubit.cancelOrder(7),
      expect: () => <OrderDetailsState>[],
      verify: (_) => verifyNever(
        () => mockCancelOrderUseCase.call(orderId: any(named: 'orderId')),
      ),
    );

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'emits cancelling then cancelled loaded state when use case succeeds',
      build: () {
        when(
          () => mockCancelOrderUseCase.call(orderId: 7),
        ).thenAnswer((_) async => const ApiSuccess(null));
        return cubit;
      },
      seed: () => const OrderDetailsLoaded(order: tOrder),
      act: (cubit) => cubit.cancelOrder(7),
      expect: () => [
        isA<OrderDetailsLoaded>()
            .having((state) => state.order, 'order', tOrder)
            .having((state) => state.isCancelling, 'isCancelling', true)
            .having((state) => state.cancelFailure, 'cancelFailure', isNull),
        isA<OrderDetailsLoaded>()
            .having(
              (state) => state.order.status,
              'order status',
              OrderStatus.cancelled,
            )
            .having((state) => state.isCancelling, 'isCancelling', false)
            .having(
              (state) => state.isCancelledSuccessfully,
              'isCancelledSuccessfully',
              true,
            )
            .having((state) => state.cancelFailure, 'cancelFailure', isNull),
      ],
      verify: (_) {
        verify(() => mockCancelOrderUseCase.call(orderId: 7)).called(1);
        verify(
          () => mockOrdersListCubit.updateOrderStatusLocally(
            7,
            OrderStatus.cancelled,
          ),
        ).called(1);
      },
    );

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'emits cancelling then loaded state with cancel failure when use case fails',
      build: () {
        when(
          () => mockCancelOrderUseCase.call(orderId: 7),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      seed: () => const OrderDetailsLoaded(order: tOrder),
      act: (cubit) => cubit.cancelOrder(7),
      expect: () => [
        isA<OrderDetailsLoaded>()
            .having((state) => state.isCancelling, 'isCancelling', true)
            .having((state) => state.cancelFailure, 'cancelFailure', isNull),
        isA<OrderDetailsLoaded>()
            .having((state) => state.order, 'order', tOrder)
            .having((state) => state.isCancelling, 'isCancelling', false)
            .having((state) => state.cancelFailure, 'cancelFailure', tFailure),
      ],
      verify: (_) {
        verify(() => mockCancelOrderUseCase.call(orderId: 7)).called(1);
        verifyNever(
          () => mockOrdersListCubit.updateOrderStatusLocally(any(), any()),
        );
      },
    );

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'clears previous cancel failure before retrying cancellation',
      build: () {
        when(
          () => mockCancelOrderUseCase.call(orderId: 7),
        ).thenAnswer((_) async => const ApiSuccess(null));
        return cubit;
      },
      seed: () => OrderDetailsLoaded(order: tOrder, cancelFailure: tFailure),
      act: (cubit) => cubit.cancelOrder(7),
      expect: () => [
        isA<OrderDetailsLoaded>()
            .having((state) => state.isCancelling, 'isCancelling', true)
            .having((state) => state.cancelFailure, 'cancelFailure', isNull),
        isA<OrderDetailsLoaded>()
            .having(
              (state) => state.order.status,
              'order status',
              OrderStatus.cancelled,
            )
            .having((state) => state.cancelFailure, 'cancelFailure', isNull),
      ],
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/features/orders/data/datasources/remote/orders_remote_datasource.dart';
import 'package:tech_nest/features/orders/data/models/order_details_model.dart';
import 'package:tech_nest/features/orders/data/models/order_item_model.dart';
import 'package:tech_nest/features/orders/data/models/order_model.dart';
import 'package:tech_nest/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';

class MockOrdersRemoteDatasource extends Mock
    implements OrdersRemoteDatasource {}

void main() {
  late OrdersRepositoryImpl repository;
  late MockOrdersRemoteDatasource mockDataSource;

  const tParams = CreateOrderParams(
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
  );

  const tOrderModel = OrderModel(
    id: 7,
    totalPrice: 349.99,
    status: 'pending',
    createdAt: '2026-05-20T10:00:00Z',
    updatedAt: '2026-05-21T10:00:00Z',
  );

  const tOrderItemModel = OrderItemModel(
    orderItemId: 1,
    quantity: 2,
    price: 149.50,
    productId: 10,
    name: 'Mechanical Keyboard',
    imageUrl: 'keyboard.png',
  );

  const tOrderDetailsModel = OrderDetailsModel(
    id: 7,
    totalPrice: 349.99,
    status: 'confirmed',
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
    createdAt: '2026-05-20T10:00:00Z',
    updatedAt: '2026-05-21T10:00:00Z',
    items: [tOrderItemModel],
  );

  setUp(() {
    mockDataSource = MockOrdersRemoteDatasource();
    repository = OrdersRepositoryImpl(mockDataSource);
  });

  group('createOrder', () {
    test(
      'returns Right with order id when remote datasource succeeds',
      () async {
        when(
          () => mockDataSource.createOrder(params: tParams),
        ).thenAnswer((_) async => 7);

        final result = await repository.createOrder(params: tParams);

        expect(result, isA<ApiSuccess<int>>());
        result.fold(
          (_) => fail('Expected success'),
          (orderId) => expect(orderId, 7),
        );
        verify(() => mockDataSource.createOrder(params: tParams)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'returns ServerFailure when remote datasource throws ServerException',
      () async {
        when(
          () => mockDataSource.createOrder(params: tParams),
        ).thenThrow(ServerException('Server error'));

        final result = await repository.createOrder(params: tParams);

        expect(result, isA<ApiFailure<int>>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns NetworkFailure when remote datasource throws NetworkException',
      () async {
        when(
          () => mockDataSource.createOrder(params: tParams),
        ).thenThrow(NetworkException());

        final result = await repository.createOrder(params: tParams);

        expect(result, isA<ApiFailure<int>>());
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns UnknownFailure when remote datasource throws unexpected exception',
      () async {
        when(
          () => mockDataSource.createOrder(params: tParams),
        ).thenThrow(Exception('Unexpected'));

        final result = await repository.createOrder(params: tParams);

        expect(result, isA<ApiFailure<int>>());
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );
  });

  group('getUserOrders', () {
    test(
      'returns mapped OrderEntity list when remote datasource succeeds',
      () async {
        when(
          () => mockDataSource.getUserOrders(),
        ).thenAnswer((_) async => [tOrderModel]);

        final result = await repository.getUserOrders();

        expect(result, isA<ApiSuccess<List<OrderEntity>>>());
        result.fold((_) => fail('Expected success'), (orders) {
          expect(orders, hasLength(1));
          expect(orders.first.id, tOrderModel.id);
          expect(orders.first.totalPrice, tOrderModel.totalPrice);
          expect(orders.first.status, OrderStatus.pending);
          expect(orders.first.createdAt, tOrderModel.createdAt);
          expect(orders.first.updatedAt, tOrderModel.updatedAt);
        });
        verify(() => mockDataSource.getUserOrders()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'returns an empty list when remote datasource returns no orders',
      () async {
        when(() => mockDataSource.getUserOrders()).thenAnswer((_) async => []);

        final result = await repository.getUserOrders();

        result.fold(
          (_) => fail('Expected success'),
          (orders) => expect(orders, isEmpty),
        );
      },
    );

    test(
      'returns ServerFailure when remote datasource throws ServerException',
      () async {
        when(
          () => mockDataSource.getUserOrders(),
        ).thenThrow(ServerException(''));

        final result = await repository.getUserOrders();

        expect(result, isA<ApiFailure<List<OrderEntity>>>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns NetworkFailure when remote datasource throws NetworkException',
      () async {
        when(
          () => mockDataSource.getUserOrders(),
        ).thenThrow(NetworkException());

        final result = await repository.getUserOrders();

        expect(result, isA<ApiFailure<List<OrderEntity>>>());
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns UnknownFailure when remote datasource throws unexpected exception',
      () async {
        when(
          () => mockDataSource.getUserOrders(),
        ).thenThrow(StateError('Unexpected'));

        final result = await repository.getUserOrders();

        expect(result, isA<ApiFailure<List<OrderEntity>>>());
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );
  });

  group('getOrderDetails', () {
    test(
      'returns mapped OrderDetailsEntity when remote datasource succeeds',
      () async {
        when(
          () => mockDataSource.getOrderDetails(orderId: 7),
        ).thenAnswer((_) async => tOrderDetailsModel);

        final result = await repository.getOrderDetails(orderId: 7);

        expect(result, isA<ApiSuccess<OrderDetailsEntity>>());
        result.fold((_) => fail('Expected success'), (order) {
          expect(order.id, tOrderDetailsModel.id);
          expect(order.totalPrice, tOrderDetailsModel.totalPrice);
          expect(order.status, OrderStatus.confirmed);
          expect(order.shippingAddress, tOrderDetailsModel.shippingAddress);
          expect(order.billingAddress, tOrderDetailsModel.billingAddress);
          expect(order.items, hasLength(1));
          expect(order.items.first.productId, tOrderItemModel.productId);
        });
        verify(() => mockDataSource.getOrderDetails(orderId: 7)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'returns ServerFailure when remote datasource throws ServerException',
      () async {
        when(
          () => mockDataSource.getOrderDetails(orderId: 7),
        ).thenThrow(ServerException(''));

        final result = await repository.getOrderDetails(orderId: 7);

        expect(result, isA<ApiFailure<OrderDetailsEntity>>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns NetworkFailure when remote datasource throws NetworkException',
      () async {
        when(
          () => mockDataSource.getOrderDetails(orderId: 7),
        ).thenThrow(NetworkException());

        final result = await repository.getOrderDetails(orderId: 7);

        expect(result, isA<ApiFailure<OrderDetailsEntity>>());
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns UnknownFailure when remote datasource throws unexpected exception',
      () async {
        when(
          () => mockDataSource.getOrderDetails(orderId: 7),
        ).thenThrow(Exception('Unexpected'));

        final result = await repository.getOrderDetails(orderId: 7);

        expect(result, isA<ApiFailure<OrderDetailsEntity>>());
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );
  });

  group('cancelOrder', () {
    test('returns Right null when remote datasource succeeds', () async {
      when(
        () => mockDataSource.cancelOrder(orderId: 7),
      ).thenAnswer((_) async {});

      final result = await repository.cancelOrder(orderId: 7);

      expect(result, isA<ApiSuccess<void>>());
      result.fold((_) => fail('Expected success'), (_) {});
      verify(() => mockDataSource.cancelOrder(orderId: 7)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test(
      'returns ServerFailure when remote datasource throws ServerException',
      () async {
        when(
          () => mockDataSource.cancelOrder(orderId: 7),
        ).thenThrow(ServerException(''));

        final result = await repository.cancelOrder(orderId: 7);

        expect(result, isA<ApiFailure<void>>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns NetworkFailure when remote datasource throws NetworkException',
      () async {
        when(
          () => mockDataSource.cancelOrder(orderId: 7),
        ).thenThrow(NetworkException());

        final result = await repository.cancelOrder(orderId: 7);

        expect(result, isA<ApiFailure<void>>());
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test(
      'returns UnknownFailure when remote datasource throws unexpected exception',
      () async {
        when(
          () => mockDataSource.cancelOrder(orderId: 7),
        ).thenThrow(Exception('Unexpected'));

        final result = await repository.cancelOrder(orderId: 7);

        expect(result, isA<ApiFailure<void>>());
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );
  });
}

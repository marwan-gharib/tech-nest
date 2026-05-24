import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/orders/data/datasources/remote/orders_remote_datasource.dart';
import 'package:tech_nest/features/orders/data/models/order_details_model.dart';
import 'package:tech_nest/features/orders/data/models/order_model.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late OrdersRemoteDatasource datasource;
  late MockApiClient mockApiClient;

  const tParams = CreateOrderParams(
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
  );

  final tOrderJson = {
    'id': 7,
    'total_price': 349.99,
    'status': 'pending',
    'created_at': '2026-05-20T10:00:00Z',
    'updated_at': '2026-05-21T10:00:00Z',
  };

  final tOrderDetailsJson = {
    'id': 7,
    'total_price': 349.99,
    'status': 'confirmed',
    'shipping_address': 'Cairo, Egypt',
    'billing_address': 'Giza, Egypt',
    'created_at': '2026-05-20T10:00:00Z',
    'updated_at': '2026-05-21T10:00:00Z',
    'items': [
      {
        'order_item_id': 1,
        'quantity': 2,
        'price': 149.50,
        'product_id': 10,
        'name': 'Mechanical Keyboard',
        'image_url': 'keyboard.png',
      },
    ],
  };

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = OrdersRemoteDatasource(mockApiClient);
  });

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('createOrder', () {
    test('returns order id when response contains numeric order id', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => {
          ApiKeys.data: {ApiKeys.orderId: 7},
        },
      );

      final result = await datasource.createOrder(params: tParams);

      expect(result, 7);
      verify(
        () => mockApiClient.post(Endpoints.createOrder, data: tParams.toJson()),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('returns order id when response contains string order id', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => {
          ApiKeys.data: {ApiKeys.orderId: '7'},
        },
      );

      final result = await datasource.createOrder(params: tParams);

      expect(result, 7);
    });

    test('throws UnKnownException when response is null', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.createOrder(params: tParams),
        throwsA(isA<UnKnownException>()),
      );
    });

    test('throws UnKnownException when order id is missing', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => {ApiKeys.data: <String, dynamic>{}});

      expect(
        () => datasource.createOrder(params: tParams),
        throwsA(isA<UnKnownException>()),
      );
    });

    test('throws UnKnownException when order id is not parseable', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => {
          ApiKeys.data: {ApiKeys.orderId: 'invalid'},
        },
      );

      expect(
        () => datasource.createOrder(params: tParams),
        throwsA(isA<UnKnownException>()),
      );
    });

    test('rethrows AppException from API client', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenThrow(ServerException('Server error'));

      expect(
        () => datasource.createOrder(params: tParams),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'throws UnKnownException when API client throws generic exception',
      () async {
        when(
          () => mockApiClient.post(any(), data: any(named: 'data')),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.createOrder(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('getUserOrders', () {
    test(
      'returns OrderModel list when response contains valid orders',
      () async {
        when(() => mockApiClient.get(any())).thenAnswer(
          (_) async => {
            ApiKeys.data: {
              ApiKeys.orders: [tOrderJson],
            },
          },
        );

        final result = await datasource.getUserOrders();

        expect(result, isA<List<OrderModel>>());
        expect(result, hasLength(1));
        expect(result.first.id, 7);
        expect(result.first.totalPrice, 349.99);
        verify(() => mockApiClient.get(Endpoints.listOrders)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'returns empty list when response contains empty orders list',
      () async {
        when(() => mockApiClient.get(any())).thenAnswer(
          (_) async => {
            ApiKeys.data: {ApiKeys.orders: <dynamic>[]},
          },
        );

        final result = await datasource.getUserOrders();

        expect(result, isEmpty);
      },
    );

    test('throws UnKnownException when response is null', () async {
      when(() => mockApiClient.get(any())).thenAnswer((_) async => null);

      expect(datasource.getUserOrders, throwsA(isA<UnKnownException>()));
    });

    test('throws UnKnownException when orders payload is not a list', () async {
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => {
          ApiKeys.data: {ApiKeys.orders: <String, dynamic>{}},
        },
      );

      expect(datasource.getUserOrders, throwsA(isA<UnKnownException>()));
    });

    test('throws UnKnownException when order JSON is invalid', () async {
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => {
          ApiKeys.data: {
            ApiKeys.orders: [
              {'id': 'invalid'},
            ],
          },
        },
      );

      expect(datasource.getUserOrders, throwsA(isA<UnKnownException>()));
    });

    test('rethrows AppException from API client', () async {
      when(() => mockApiClient.get(any())).thenThrow(NetworkException());

      expect(datasource.getUserOrders, throwsA(isA<NetworkException>()));
    });

    test(
      'throws UnKnownException when API client throws generic exception',
      () async {
        when(() => mockApiClient.get(any())).thenThrow(Exception('Unexpected'));

        expect(datasource.getUserOrders, throwsA(isA<UnKnownException>()));
      },
    );
  });

  group('getOrderDetails', () {
    test(
      'returns OrderDetailsModel when response contains valid order',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => {
            ApiKeys.data: {ApiKeys.order: tOrderDetailsJson},
          },
        );

        final result = await datasource.getOrderDetails(orderId: 7);

        expect(result, isA<OrderDetailsModel>());
        expect(result.id, 7);
        expect(result.items, hasLength(1));
        verify(
          () => mockApiClient.get(
            Endpoints.orderDetails,
            queryParameters: {'id': 7},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('throws UnKnownException when response is null', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.getOrderDetails(orderId: 7),
        throwsA(isA<UnKnownException>()),
      );
    });

    test('throws UnKnownException when order payload is missing', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => {ApiKeys.data: <String, dynamic>{}});

      expect(
        () => datasource.getOrderDetails(orderId: 7),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'throws UnKnownException when order payload has invalid shape',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => {
            ApiKeys.data: {
              ApiKeys.order: <String, dynamic>{'id': 'invalid'},
            },
          },
        );

        expect(
          () => datasource.getOrderDetails(orderId: 7),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test('rethrows AppException from API client', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(ServerException('Server error'));

      expect(
        () => datasource.getOrderDetails(orderId: 7),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'throws UnKnownException when API client throws generic exception',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.getOrderDetails(orderId: 7),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('cancelOrder', () {
    test('calls delete endpoint with order id', () async {
      when(
        () => mockApiClient.delete(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => null);

      await datasource.cancelOrder(orderId: 7);

      verify(
        () => mockApiClient.delete(
          Endpoints.cancelOrder,
          queryParameters: {'id': 7},
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('rethrows AppException from API client', () async {
      when(
        () => mockApiClient.delete(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(ServerException('Server error'));

      expect(
        () => datasource.cancelOrder(orderId: 7),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'throws UnKnownException when API client throws generic exception',
      () async {
        when(
          () => mockApiClient.delete(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.cancelOrder(orderId: 7),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });
}

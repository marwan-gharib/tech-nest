import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/data/models/cart_item_model.dart';
import 'package:tech_nest/features/cart/data/models/cart_model.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late CartRemoteDatasource dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = CartRemoteDatasource(mockApiClient);
  });

  final tAddToCartParams = AddToCartParams(productId: 1, quantity: 2);
  final tUpdateItemQuantityParams = UpdateItemQuantityParams(
    cartId: 1,
    quantity: 3,
  );

  group('addToCart', () {
    test('should return CartItemModel when response is valid', () async {
      final jsonMap = {
        ApiKeys.data: {
          ApiKeys.id: 1,
          ApiKeys.quantity: 2,
          ApiKeys.product: {
            ApiKeys.id: 1,
            ApiKeys.name: 'Test Product',
            ApiKeys.description: 'Test Description',
            ApiKeys.price: 100.0,
            ApiKeys.stock: 10,
            ApiKeys.category: {
              ApiKeys.id: 1,
              ApiKeys.name: 'Cat',
              ApiKeys.imgUrl: 'img.png',
            },
            ApiKeys.imgUrl: 'img.jpg',
          },
        },
      };

      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => jsonMap);

      final result = await dataSource.addToCart(params: tAddToCartParams);

      expect(result, isA<CartItemModel>());
      expect(result.id, 1);
      expect(result.quantity, 2);
    });

    test(
      'should throw ServerException when ApiClient throws ServerException',
      () async {
        when(
          () => mockApiClient.post(any(), data: any(named: 'data')),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => dataSource.addToCart(params: tAddToCartParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => null);

      expect(
        () => dataSource.addToCart(params: tAddToCartParams),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('getCartItems', () {
    test('should return CartModel when response is valid', () async {
      final jsonMap = {
        ApiKeys.data: {
          ApiKeys.items: [],
          ApiKeys.totalQuantity: 0,
          ApiKeys.totalPrice: 0,
          ApiKeys.deliveryCharges: 0,
          ApiKeys.grandTotal: 0,
        },
      };

      when(() => mockApiClient.get(any())).thenAnswer((_) async => jsonMap);

      final result = await dataSource.getCartItems();

      expect(result, isA<CartModel>());
    });

    test(
      'should throw ServerException when ApiClient throws ServerException',
      () async {
        when(
          () => mockApiClient.get(any()),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => dataSource.getCartItems(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('removeFromCart', () {
    test('should return cartId when response is valid', () async {
      final jsonMap = {
        ApiKeys.data: {ApiKeys.id: 1},
      };

      when(
        () => mockApiClient.delete(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => jsonMap);

      final result = await dataSource.removeFromCart(cartId: 1);

      expect(result, 1);
    });

    test(
      'should throw ServerException when ApiClient throws ServerException',
      () async {
        when(
          () => mockApiClient.delete(any(), data: any(named: 'data')),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => dataSource.removeFromCart(cartId: 1),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('updateItemQuantity', () {
    test('should return updated quantity when response is valid', () async {
      final jsonMap = {
        ApiKeys.data: {ApiKeys.quantity: 3},
      };

      when(
        () => mockApiClient.patch(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => jsonMap);

      final result = await dataSource.updateItemQuantity(
        params: tUpdateItemQuantityParams,
      );

      expect(result, 3);
    });

    test(
      'should throw ServerException when ApiClient throws ServerException',
      () async {
        when(
          () => mockApiClient.patch(any(), data: any(named: 'data')),
        ).thenThrow(ServerException('Server error'));

        expect(
          () =>
              dataSource.updateItemQuantity(params: tUpdateItemQuantityParams),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}

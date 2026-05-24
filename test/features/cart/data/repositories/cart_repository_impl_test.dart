import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/data/models/cart_item_model.dart';
import 'package:tech_nest/features/cart/data/models/cart_model.dart';
import 'package:tech_nest/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

class MockCartRemoteDatasource extends Mock implements CartRemoteDatasource {}

class MockCartItemModel extends Mock implements CartItemModel {}

class MockCartModel extends Mock implements CartModel {}

class MockCartItem extends Mock implements CartItem {}

class MockCart extends Mock implements Cart {}

void main() {
  late CartRepositoryImpl repository;
  late MockCartRemoteDatasource mockDataSource;

  setUp(() {
    mockDataSource = MockCartRemoteDatasource();
    repository = CartRepositoryImpl(mockDataSource);
  });

  final tAddToCartParams = AddToCartParams(productId: 1, quantity: 2);
  final tUpdateItemQuantityParams = UpdateItemQuantityParams(
    cartId: 1,
    quantity: 3,
  );

  group('addToCart', () {
    test(
      'should return CartItem when data source call is successful',
      () async {
        final mockModel = MockCartItemModel();
        final mockEntity = MockCartItem();
        when(() => mockModel.toEntity()).thenReturn(mockEntity);
        when(
          () => mockDataSource.addToCart(params: tAddToCartParams),
        ).thenAnswer((_) async => mockModel);

        final result = await repository.addToCart(params: tAddToCartParams);

        expect(result, equals(Right(mockEntity)));
        verify(
          () => mockDataSource.addToCart(params: tAddToCartParams),
        ).called(1);
      },
    );

    test(
      'should return Failure when data source throws AppException',
      () async {
        when(
          () => mockDataSource.addToCart(params: tAddToCartParams),
        ).thenThrow(ServerException('Server error'));

        final result = await repository.addToCart(params: tAddToCartParams);

        expect(result, isA<Left<Failure, CartItem>>());
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      },
    );

    test(
      'should return UnknownFailure when data source throws unknown exception',
      () async {
        when(
          () => mockDataSource.addToCart(params: tAddToCartParams),
        ).thenThrow(Exception());

        final result = await repository.addToCart(params: tAddToCartParams);

        expect(result, isA<Left<Failure, CartItem>>());
      },
    );
  });

  group('getCartItems', () {
    test('should return Cart when data source call is successful', () async {
      final mockModel = MockCartModel();
      final mockEntity = MockCart();
      when(() => mockModel.toEntity()).thenReturn(mockEntity);
      when(
        () => mockDataSource.getCartItems(),
      ).thenAnswer((_) async => mockModel);

      final result = await repository.getCartItems();

      expect(result, equals(Right(mockEntity)));
      verify(() => mockDataSource.getCartItems()).called(1);
    });

    test(
      'should return Failure when data source throws AppException',
      () async {
        when(
          () => mockDataSource.getCartItems(),
        ).thenThrow(ServerException('Server error'));

        final result = await repository.getCartItems();

        expect(result, isA<Left<Failure, Cart>>());
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      },
    );

    test(
      'should return UnknownFailure when data source throws unknown exception',
      () async {
        when(() => mockDataSource.getCartItems()).thenThrow(Exception());

        final result = await repository.getCartItems();

        expect(result, isA<Left<Failure, Cart>>());
      },
    );
  });

  group('removeFromCart', () {
    test('should return int when data source call is successful', () async {
      when(
        () => mockDataSource.removeFromCart(cartId: 1),
      ).thenAnswer((_) async => 1);

      final result = await repository.removeFromCart(cartId: 1);

      expect(result, equals(const Right(1)));
      verify(() => mockDataSource.removeFromCart(cartId: 1)).called(1);
    });

    test(
      'should return Failure when data source throws AppException',
      () async {
        when(
          () => mockDataSource.removeFromCart(cartId: 1),
        ).thenThrow(ServerException('Server error'));

        final result = await repository.removeFromCart(cartId: 1);

        expect(result, isA<Left<Failure, int>>());
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      },
    );

    test(
      'should return UnknownFailure when data source throws unknown exception',
      () async {
        when(
          () => mockDataSource.removeFromCart(cartId: 1),
        ).thenThrow(Exception());

        final result = await repository.removeFromCart(cartId: 1);

        expect(result, isA<Left<Failure, int>>());
      },
    );
  });

  group('updateItemQuantity', () {
    test('should return int when data source call is successful', () async {
      when(
        () => mockDataSource.updateItemQuantity(
          params: tUpdateItemQuantityParams,
        ),
      ).thenAnswer((_) async => 3);

      final result = await repository.updateItemQuantity(
        params: tUpdateItemQuantityParams,
      );

      expect(result, equals(const Right(3)));
      verify(
        () => mockDataSource.updateItemQuantity(
          params: tUpdateItemQuantityParams,
        ),
      ).called(1);
    });

    test(
      'should return Failure when data source throws AppException',
      () async {
        when(
          () => mockDataSource.updateItemQuantity(
            params: tUpdateItemQuantityParams,
          ),
        ).thenThrow(ServerException('Server error'));

        final result = await repository.updateItemQuantity(
          params: tUpdateItemQuantityParams,
        );

        expect(result, isA<Left<Failure, int>>());
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      },
    );

    test(
      'should return UnknownFailure when data source throws unknown exception',
      () async {
        when(
          () => mockDataSource.updateItemQuantity(
            params: tUpdateItemQuantityParams,
          ),
        ).thenThrow(Exception());

        final result = await repository.updateItemQuantity(
          params: tUpdateItemQuantityParams,
        );

        expect(result, isA<Left<Failure, int>>());
      },
    );
  });

  group('clearCart', () {
    test('should return empty Cart when called', () async {
      final result = await repository.clearCart();

      expect(result, isA<Right<Failure, Cart>>());
      final cart = result.fold((l) => null, (r) => r)!;
      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0);
      expect(cart.deliveryCharges, 0);
      expect(cart.grandTotal, 0);
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

class MockGetCartItemsUsecase extends Mock implements GetCartItemsUsecase {}

class MockAddToCartUsecase extends Mock implements AddToCartUsecase {}

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}

void main() {
  late CartCubit cartCubit;
  late MockGetCartItemsUsecase mockGetCartItemsUsecase;
  late MockAddToCartUsecase mockAddToCartUsecase;
  late MockClearCartUseCase mockClearCartUseCase;

  setUp(() {
    mockGetCartItemsUsecase = MockGetCartItemsUsecase();
    mockAddToCartUsecase = MockAddToCartUsecase();
    mockClearCartUseCase = MockClearCartUseCase();
    cartCubit = CartCubit(
      mockGetCartItemsUsecase,
      mockAddToCartUsecase,
      mockClearCartUseCase,
    );
    registerFallbackValue(AddToCartParams(productId: 1, quantity: 1));
  });

  tearDown(() {
    cartCubit.close();
  });

  final tFailure = ServerFailure(message: 'Server Error');
  const tProduct = ProductEntity(
    id: 1,
    name: 'Product 1',
    description: 'Desc',
    price: 100.0,
    stock: 10,
    category: CategoryEntity.empty(),
    imgUrl: 'img.jpg',
  );
  final tCartItem = CartItem(id: 1, quantity: 2, product: tProduct);
  final tCart = Cart(
    items: [tCartItem],
    totalQuantity: 2,
    totalPrice: 200,
    deliveryCharges: 50,
    grandTotal: 250,
  );
  final tEmptyCart = Cart(
    items: [],
    totalQuantity: 0,
    totalPrice: 0,
    deliveryCharges: 0,
    grandTotal: 0,
  );

  test('initial state should be CartInitial', () {
    expect(cartCubit.state, const CartInitial());
  });

  group('fetchCart', () {
    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartLoaded] when usecase succeeds',
      build: () {
        when(
          () => mockGetCartItemsUsecase.call(),
        ).thenAnswer((_) async => Right(tCart));
        return cartCubit;
      },
      act: (cubit) => cubit.fetchCart(),
      expect: () => [const CartLoading(), CartLoaded(cart: tCart)],
      verify: (_) => verify(() => mockGetCartItemsUsecase.call()).called(1),
    );

    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartFailed] when usecase fails',
      build: () {
        when(
          () => mockGetCartItemsUsecase.call(),
        ).thenAnswer((_) async => Left(tFailure));
        return cartCubit;
      },
      act: (cubit) => cubit.fetchCart(),
      expect: () => [const CartLoading(), CartFailed(failure: tFailure)],
      verify: (_) => verify(() => mockGetCartItemsUsecase.call()).called(1),
    );
  });

  group('add', () {
    blocTest<CartCubit, CartState>(
      'emits states with isMutating and updates cart correctly on success',
      build: () {
        when(
          () => mockAddToCartUsecase.call(params: any(named: 'params')),
        ).thenAnswer((_) async => Right(tCartItem));
        return cartCubit;
      },
      seed: () => CartLoaded(cart: tEmptyCart),
      act: (cubit) => cubit.add(productId: 1, quantity: 2),
      expect: () {
        return [
          isA<CartLoaded>().having((s) => s.isMutating, 'isMutating', true),
          isA<CartLoaded>()
              .having((s) => s.isMutating, 'isMutating', false)
              .having((s) => s.cart.items.length, 'cart.items.length', 1),
        ];
      },
    );

    blocTest<CartCubit, CartState>(
      'emits states with mutationFailure when usecase fails',
      build: () {
        when(
          () => mockAddToCartUsecase.call(params: any(named: 'params')),
        ).thenAnswer((_) async => Left(tFailure));
        return cartCubit;
      },
      seed: () => CartLoaded(cart: tCart),
      act: (cubit) => cubit.add(productId: 2, quantity: 1),
      expect: () => [
        CartLoaded(cart: tCart, isMutating: true),
        CartLoaded(cart: tCart, isMutating: false, mutationFailure: tFailure),
      ],
    );
  });

  group('clearCart', () {
    blocTest<CartCubit, CartState>(
      'emits states and clears cart successfully',
      build: () {
        when(
          () => mockClearCartUseCase.call(),
        ).thenAnswer((_) async => Right(tEmptyCart));
        return cartCubit;
      },
      seed: () => CartLoaded(cart: tCart),
      act: (cubit) => cubit.clearCart(),
      expect: () => [
        CartLoaded(cart: tCart, isMutating: true),
        CartLoaded(cart: tEmptyCart),
      ],
    );

    blocTest<CartCubit, CartState>(
      'emits CartFailed when clear cart usecase fails',
      build: () {
        when(
          () => mockClearCartUseCase.call(),
        ).thenAnswer((_) async => Left(tFailure));
        return cartCubit;
      },
      seed: () => CartLoaded(cart: tCart),
      act: (cubit) => cubit.clearCart(),
      expect: () => [
        CartLoaded(cart: tCart, isMutating: true),
        CartFailed(failure: tFailure),
      ],
    );
  });
}

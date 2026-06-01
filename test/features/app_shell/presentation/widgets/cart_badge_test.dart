import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/features/app_shell/presentation/widgets/cart_badge.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

import '../../../../helpers/test_app.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockCartCubit mockCartCubit;

  final cartWithItems = Cart(
    items: [
      CartItem(
        id: 1,
        quantity: 2,
        product: const ProductEntity(
          id: 10,
          name: 'Phone',
          description: 'Phone',
          price: 1000,
          stock: 5,
          category: CategoryEntity(id: 1, name: 'Electronics', imgUrl: ''),
          imgUrl: '',
        ),
      ),
    ],
    totalQuantity: 2,
    totalPrice: 2000,
    deliveryCharges: 0,
    grandTotal: 2000,
  );

  setUp(() {
    mockCartCubit = MockCartCubit();
    when(() => mockCartCubit.state).thenReturn(const CartInitial());
  });

  testWidgets('renders empty widget when cart is not loaded', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CartCubit>.value(
          value: mockCartCubit,
          child: const Scaffold(body: Stack(children: [CartBadge()])),
        ),
      ),
    );

    expect(find.byType(SizedBox), findsWidgets);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('renders badge with item count when cart has items', (
    tester,
  ) async {
    when(() => mockCartCubit.state).thenReturn(CartLoaded(cart: cartWithItems));

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CartCubit>.value(
          value: mockCartCubit,
          child: const Scaffold(body: Stack(children: [CartBadge()])),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('rebuilds from hidden to visible and back on state transitions', (
    tester,
  ) async {
    whenListen(
      mockCartCubit,
      (() async* {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        yield CartLoaded(cart: cartWithItems);
        await Future<void>.delayed(const Duration(milliseconds: 1500));
        yield const CartInitial();
      })(),
      initialState: const CartInitial(),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CartCubit>.value(
          value: mockCartCubit,
          child: const Scaffold(body: Stack(children: [CartBadge()])),
        ),
      ),
    );

    expect(find.text('1'), findsNothing);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('1'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    expect(find.text('1'), findsNothing);
  });
}

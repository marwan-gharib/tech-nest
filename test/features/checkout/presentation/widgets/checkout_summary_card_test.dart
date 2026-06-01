import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/shared/cart_details_widget.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/checkout_summary_card.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

import '../../../../helpers/test_app.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockCartCubit mockCartCubit;

  final cart = Cart(
    items: [
      CartItem(
        id: 1,
        quantity: 1,
        product: const ProductEntity(
          id: 1,
          name: 'Laptop',
          description: 'Laptop',
          price: 1000,
          stock: 5,
          category: CategoryEntity(id: 1, name: 'Electronics', imgUrl: ''),
          imgUrl: '',
        ),
      ),
    ],
    totalQuantity: 1,
    totalPrice: 1000,
    deliveryCharges: 50,
    grandTotal: 1050,
  );

  setUp(() {
    mockCartCubit = MockCartCubit();
    when(() => mockCartCubit.state).thenReturn(const CartInitial());
  });

  testWidgets('renders empty content when cart is not loaded', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CartCubit>.value(
          value: mockCartCubit,
          child: const Scaffold(body: CheckoutSummaryCard()),
        ),
      ),
    );

    expect(find.byType(CartDetailsWidget), findsNothing);
  });

  testWidgets('renders cart details when cart is loaded', (tester) async {
    when(() => mockCartCubit.state).thenReturn(CartLoaded(cart: cart));

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CartCubit>.value(
          value: mockCartCubit,
          child: const Scaffold(body: CheckoutSummaryCard()),
        ),
      ),
    );

    expect(find.byType(CartDetailsWidget), findsOneWidget);
  });

  testWidgets('rebuilds between empty and loaded states', (tester) async {
    whenListen(
      mockCartCubit,
      Stream<CartState>.periodic(
        const Duration(milliseconds: 10),
        (index) => [CartLoaded(cart: cart), const CartInitial()][index],
      ).take(2),
      initialState: const CartInitial(),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CartCubit>.value(
          value: mockCartCubit,
          child: const Scaffold(body: CheckoutSummaryCard()),
        ),
      ),
    );

    expect(find.byType(CartDetailsWidget), findsNothing);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(CartDetailsWidget), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(CartDetailsWidget), findsNothing);
  });
}

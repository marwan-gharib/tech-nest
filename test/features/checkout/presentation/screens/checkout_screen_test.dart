import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_state.dart';
import 'package:tech_nest/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockCreateOrderCubit extends MockCubit<CreateOrderState>
    implements CreateOrderCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockCreateOrderCubit mockCreateOrderCubit;
  late MockCartCubit mockCartCubit;

  setUpAll(() {
    registerFallbackValue(
      const CreateOrderParams(shippingAddress: 'x', billingAddress: 'y'),
    );
  });

  setUp(() {
    mockCreateOrderCubit = MockCreateOrderCubit();
    mockCartCubit = MockCartCubit();

    when(
      () => mockCreateOrderCubit.state,
    ).thenReturn(const CreateOrderInitial());
    when(
      () => mockCreateOrderCubit.createOrder(any()),
    ).thenAnswer((_) async {});
    when(() => mockCartCubit.state).thenReturn(const CartInitial());
    when(() => mockCartCubit.clearCart()).thenAnswer((_) async {});
  });

  GoRouter buildRouter({String initialLocation = '/checkout'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/cart',
          builder: (_, _) => const Scaffold(body: Text('cart-screen')),
          routes: [
            GoRoute(
              path: 'checkout',
              builder: (_, _) => MultiBlocProvider(
                providers: [
                  BlocProvider<CreateOrderCubit>.value(
                    value: mockCreateOrderCubit,
                  ),
                  BlocProvider<CartCubit>.value(value: mockCartCubit),
                ],
                child: const CheckoutScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/checkout',
          builder: (_, _) => MultiBlocProvider(
            providers: [
              BlocProvider<CreateOrderCubit>.value(value: mockCreateOrderCubit),
              BlocProvider<CartCubit>.value(value: mockCartCubit),
            ],
            child: const CheckoutScreen(),
          ),
        ),
        GoRoute(
          path: '/picker',
          name: RouteNames.locationPicker,
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.pop('Cairo, Egypt'),
                child: const Text('pick-cairo'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/order-details',
          name: RouteNames.orderDetails,
          builder: (_, state) => Scaffold(
            body: Text(
              'order:${state.uri.queryParameters[AppConstants.orderDetailsId]}',
            ),
          ),
        ),
      ],
    );
  }

  testWidgets('renders checkout content', (tester) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.cart.checkout), findsWidgets);
    expect(find.text(t.cart.summary), findsOneWidget);
    expect(find.text(t.orders.shippingAddress), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets(
    'shows validation snackbar and does not call createOrder when address is empty',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.orders.confirmOrder));
      await tester.pump();

      verifyNever(() => mockCreateOrderCubit.createOrder(any()));
      expect(find.text(t.checkout.selectAddressError), findsOneWidget);
    },
  );

  testWidgets('selects address then calls createOrder with mapped params', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(t.orders.pickLocation));
    await tester.pumpAndSettle();
    await tester.tap(find.text('pick-cairo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(t.orders.confirmOrder));
    await tester.pump();

    final captured =
        verify(
              () => mockCreateOrderCubit.createOrder(captureAny()),
            ).captured.single
            as CreateOrderParams;
    expect(captured.shippingAddress, 'Cairo, Egypt');
    expect(captured.billingAddress, 'Cairo, Egypt');
  });

  testWidgets(
    'reacts to success state by clearing cart and navigating to order details',
    (tester) async {
      whenListen(
        mockCreateOrderCubit,
        Stream.fromIterable([const CreateOrderSuccess(77)]),
        initialState: const CreateOrderInitial(),
      );

      await tester.pumpWidget(
        buildTestApp(
          router: buildRouter(initialLocation: '/cart/checkout'),
          child: const SizedBox.shrink(),
        ),
      );
      await tester.pumpAndSettle();

      verify(() => mockCartCubit.clearCart()).called(1);
      expect(find.text('order:77'), findsOneWidget);
    },
  );
}

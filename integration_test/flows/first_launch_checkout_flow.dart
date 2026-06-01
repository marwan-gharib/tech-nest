import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';

import '../support/e2e_test_context.dart';

void firstLaunchCheckoutFlow(E2ETestContext e2e) {
  testWidgets('first launch, validation, login, browse, cart, checkout guard', (
    tester,
  ) async {
    await e2e.pumpApp(tester);
    await e2e.waitFor(tester, find.text('Discover Tech'));

    expect(find.text('Discover Tech'), findsOneWidget);

    await e2e.tap(tester, find.byKey(const ValueKey('onboarding.skip')));
    await e2e.waitFor(tester, find.text('Log In'));

    expect(find.text('Log In'), findsWidgets);

    await e2e.tap(tester, find.byKey(const ValueKey('login.submit')));
    await e2e.waitFor(tester, find.text('Please enter your email address'));

    expect(find.text('Please enter your email address'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('login.email')),
      'customer@technest.test',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login.password')),
      'password123',
    );
    await e2e.tap(tester, find.byKey(const ValueKey('login.submit')));
    await e2e.waitFor(tester, find.text('Discover'));

    expect(e2e.api.loginCalls, 1);
    expect(sl<AuthNotifier>().isAuth, isTrue);

    await e2e.waitFor(tester, find.byKey(const ValueKey('product.card.1')));
    await e2e.tap(tester, find.byKey(const ValueKey('product.open.1')));
    await e2e.waitFor(tester, find.text('Aurora Laptop'));
    await e2e.tapVisible(
      tester,
      find.byKey(const ValueKey('productDetails.addToCart')),
    );
    await e2e.waitUntil(tester, () => e2e.api.cartItems.length == 1);

    expect(e2e.api.cartItems.length, 1);

    await e2e.tap(tester, find.byKey(const ValueKey('productDetails.back')));
    await e2e.waitFor(tester, find.byKey(const ValueKey('product.card.1')));
    await e2e.tap(tester, find.byKey(const ValueKey('nav.cart')));
    await e2e.waitFor(tester, find.text('My Cart'));

    expect(find.text('Aurora Laptop'), findsOneWidget);

    await e2e.tap(tester, find.byKey(const ValueKey('cart.checkout')));
    await e2e.waitFor(tester, find.text('Order Summary'));
    await e2e.tap(tester, find.byKey(const ValueKey('checkout.confirmOrder')));
    await e2e.waitFor(
      tester,
      find.text('Please select a delivery address to continue.'),
    );

    expect(
      find.text('Please select a delivery address to continue.'),
      findsOneWidget,
    );
    expect(e2e.api.createOrderCalls, 0);
  });
}

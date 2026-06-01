import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/e2e_test_context.dart';

void authenticatedShellFlow(E2ETestContext e2e) {
  testWidgets('authenticated shell navigates core tabs and surfaces data', (
    tester,
  ) async {
    await e2e.startAuthenticatedSession(tester);

    await e2e.waitFor(tester, find.byKey(const ValueKey('product.card.1')));

    await e2e.tap(tester, find.byKey(const ValueKey('nav.categories')));
    await e2e.waitFor(tester, find.text('Laptops'));

    await e2e.tap(tester, find.byKey(const ValueKey('nav.orders')));
    await e2e.waitFor(tester, find.text('My Orders'));
    await e2e.waitFor(tester, find.text('#9001'));
    expect(find.text('#9001'), findsOneWidget);

    await e2e.tap(tester, find.byKey(const ValueKey('nav.notifications')));
    await e2e.waitFor(tester, find.text('Notifications'));
    await e2e.waitFor(tester, find.text('Order confirmed'));
    expect(find.text('Order confirmed'), findsOneWidget);
  });
}

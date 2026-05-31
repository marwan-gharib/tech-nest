import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/checkout_address_card.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

void main() {
  testWidgets('shows initial pick-location text then updates after selection', (
    tester,
  ) async {
    String? selectedAddress;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: CheckoutAddressCard(
              onLocationSelected: (value) => selectedAddress = value,
            ),
          ),
        ),
        GoRoute(
          path: '/picker',
          name: RouteNames.locationPicker,
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.pop('Cairo, Egypt'),
                child: const Text('select-location'),
              ),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      buildTestApp(router: router, child: const SizedBox.shrink()),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.orders.pickLocation), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();
    expect(find.text('select-location'), findsOneWidget);

    await tester.tap(find.text('select-location'));
    await tester.pumpAndSettle();

    expect(find.text('Cairo, Egypt'), findsOneWidget);
    expect(selectedAddress, 'Cairo, Egypt');
  });

  testWidgets('keeps initial text when picker returns null', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: CheckoutAddressCard()),
        ),
        GoRoute(
          path: '/picker',
          name: RouteNames.locationPicker,
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('close'),
              ),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      buildTestApp(router: router, child: const SizedBox.shrink()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();
    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();

    expect(find.text(t.orders.pickLocation), findsOneWidget);
  });
}

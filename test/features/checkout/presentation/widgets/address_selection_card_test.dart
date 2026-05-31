import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/address_selection_card.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

void main() {
  testWidgets('renders notifier value and updates on notifier change', (
    tester,
  ) async {
    final notifier = ValueNotifier<String>('Address A');

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: AddressSelectionCard(
            addressNotifier: notifier,
            onConfirm: () {},
          ),
        ),
      ),
    );

    expect(find.text('Address A'), findsOneWidget);

    notifier.value = 'Address B';
    await tester.pump();

    expect(find.text('Address B'), findsOneWidget);
  });

  testWidgets('calls confirm callback when confirm button is tapped', (
    tester,
  ) async {
    final notifier = ValueNotifier<String>('Address A');
    var confirmed = false;

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: AddressSelectionCard(
            addressNotifier: notifier,
            onConfirm: () => confirmed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text(t.checkout.confirmLocation));
    await tester.pump();

    expect(confirmed, true);
  });
}

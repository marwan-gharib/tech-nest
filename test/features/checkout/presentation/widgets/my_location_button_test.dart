import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/my_location_button.dart';

import '../../../../helpers/test_app.dart';

void main() {
  testWidgets('shows location icon when not loading', (tester) async {
    final loadingNotifier = ValueNotifier<bool>(false);

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: MyLocationButton(
            onPressed: () {},
            isLoadingNotifier: loadingNotifier,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.my_location), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows loading spinner when notifier changes to loading', (
    tester,
  ) async {
    final loadingNotifier = ValueNotifier<bool>(false);

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: MyLocationButton(
            onPressed: () {},
            isLoadingNotifier: loadingNotifier,
          ),
        ),
      ),
    );

    loadingNotifier.value = true;
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.my_location), findsNothing);
  });

  testWidgets('calls callback when button is tapped', (tester) async {
    final loadingNotifier = ValueNotifier<bool>(false);
    var tapped = false;

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: MyLocationButton(
            onPressed: () => tapped = true,
            isLoadingNotifier: loadingNotifier,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(tapped, true);
  });
}

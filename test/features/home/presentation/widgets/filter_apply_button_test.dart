import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_apply_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

void main() {
  testWidgets('calls callback when enabled and tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: FilterApplyButton(
            activeCount: 2,
            enabled: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text(t.home.applyFilters(n: 2)), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, true);
  });

  testWidgets('does not call callback when disabled', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: FilterApplyButton(
            activeCount: 0,
            enabled: false,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    final opacity = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(opacity.opacity, 0.6);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, false);
  });
}

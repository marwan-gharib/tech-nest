import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/home/presentation/widgets/radio_buttons_group.dart';

import '../../../../helpers/test_app.dart';

void main() {
  testWidgets('renders all options and reports selected value on tap', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          body: RadioButtonsGroup<String>(
            values: const ['A', 'B', 'C'],
            initialValue: 'A',
            onTap: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(selected, 'B');
  });

  testWidgets('updates selected tile when initial value changes on rebuild', (
    tester,
  ) async {
    var currentValue = 'A';

    await tester.pumpWidget(
      buildTestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      currentValue = 'C';
                      setState(() {});
                    },
                    child: const Text('update'),
                  ),
                  Expanded(
                    child: RadioButtonsGroup<String>(
                      values: const ['A', 'B', 'C'],
                      initialValue: currentValue,
                      onTap: (_) {},
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('update'));
    await tester.pumpAndSettle();

    expect(find.text('C'), findsOneWidget);
  });
}

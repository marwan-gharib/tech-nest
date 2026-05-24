import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_status_chip.dart';
import 'package:tech_nest/i18n/strings.g.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  Widget buildSubject(OrderStatus status) {
    return TranslationProvider(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: Scaffold(
          body: Center(child: OrderStatusChip(status: status)),
        ),
      ),
    );
  }

  group('OrderStatusChip', () {
    testWidgets('renders pending status label', (tester) async {
      await tester.pumpWidget(buildSubject(OrderStatus.pending));

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('renders confirmed status label', (tester) async {
      await tester.pumpWidget(buildSubject(OrderStatus.confirmed));

      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('renders shipped status label', (tester) async {
      await tester.pumpWidget(buildSubject(OrderStatus.shipped));

      expect(find.text('Shipped'), findsOneWidget);
    });

    testWidgets('renders delivered status label', (tester) async {
      await tester.pumpWidget(buildSubject(OrderStatus.delivered));

      expect(find.text('Delivered'), findsOneWidget);
    });

    testWidgets('renders cancelled status label', (tester) async {
      await tester.pumpWidget(buildSubject(OrderStatus.cancelled));

      expect(find.text('Cancelled'), findsOneWidget);
    });
  });
}

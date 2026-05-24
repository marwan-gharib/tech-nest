import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';
import 'package:tech_nest/features/orders/presentation/widgets/cancel_order_dialog.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_summary.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockOrderDetailsCubit extends MockCubit<OrderDetailsState>
    implements OrderDetailsCubit {}

void main() {
  late MockOrderDetailsCubit mockOrderDetailsCubit;

  const tPendingOrder = OrderDetailsEntity(
    id: 7,
    totalPrice: 349.99,
    status: OrderStatus.pending,
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
    createdAt: '2026-05-20T10:00:00Z',
    updatedAt: '2026-05-21T10:00:00Z',
    items: [],
  );

  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  setUp(() {
    mockOrderDetailsCubit = MockOrderDetailsCubit();
    when(
      () => mockOrderDetailsCubit.state,
    ).thenReturn(const OrderDetailsLoaded(order: tPendingOrder));
    when(
      () => mockOrderDetailsCubit.cancelOrder(any()),
    ).thenAnswer((_) async {});
  });

  Widget buildSubject({
    required OrderDetailsEntity order,
    bool isCancelling = false,
  }) {
    return BlocProvider<OrderDetailsCubit>.value(
      value: mockOrderDetailsCubit,
      child: TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: Scaffold(
            body: OrderDetailsSummary(order: order, isCancelling: isCancelling),
          ),
        ),
      ),
    );
  }

  group('OrderDetailsSummary', () {
    testWidgets('renders total and cancel button for pending order', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(order: tPendingOrder));

      expect(find.text('Total'), findsOneWidget);
      expect(find.text(r'$349.99'), findsOneWidget);
      expect(find.text('Cancel Order'), findsOneWidget);
    });

    testWidgets('does not render cancel button for non-pending order', (
      tester,
    ) async {
      final deliveredOrder = tPendingOrder.copyWith(
        status: OrderStatus.delivered,
      );

      await tester.pumpWidget(buildSubject(order: deliveredOrder));

      expect(find.text(r'$349.99'), findsOneWidget);
      expect(find.text('Cancel Order'), findsNothing);
    });

    testWidgets('shows progress indicator while cancelling', (tester) async {
      await tester.pumpWidget(
        buildSubject(order: tPendingOrder, isCancelling: true),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isFalse,
      );
    });

    testWidgets('opens dialog and confirms cancellation', (tester) async {
      await tester.pumpWidget(buildSubject(order: tPendingOrder));

      await tester.tap(find.text('Cancel Order'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CancelOrderDialog), findsOneWidget);

      await tester.tap(find.text('Yes, Cancel Order'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      verify(() => mockOrderDetailsCubit.cancelOrder(7)).called(1);
    });
  });
}

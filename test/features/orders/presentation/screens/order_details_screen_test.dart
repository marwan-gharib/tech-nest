import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_item_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';
import 'package:tech_nest/features/orders/presentation/screens/order_details_screen.dart';
import 'package:tech_nest/features/orders/presentation/widgets/cancel_order_dialog.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_addresses.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_header.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_item_card.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_summary.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockOrderDetailsCubit extends MockCubit<OrderDetailsState>
    implements OrderDetailsCubit {}

void main() {
  late MockOrderDetailsCubit mockOrderDetailsCubit;

  const tOrder = OrderDetailsEntity(
    id: 7,
    totalPrice: 349.99,
    status: OrderStatus.pending,
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
    createdAt: '2026-05-20T10:00:00Z',
    updatedAt: '2026-05-21T10:00:00Z',
    items: [
      OrderItemEntity(
        orderItemId: 1,
        quantity: 2,
        price: 149.50,
        productId: 10,
        name: 'Mechanical Keyboard',
        imageUrl: 'keyboard.png',
      ),
    ],
  );

  const tReplacementOrder = OrderDetailsEntity(
    id: 8,
    totalPrice: 120,
    status: OrderStatus.delivered,
    shippingAddress: 'Alexandria, Egypt',
    billingAddress: 'Alexandria, Egypt',
    createdAt: '2026-05-22T10:00:00Z',
    updatedAt: '2026-05-23T10:00:00Z',
    items: [],
  );

  final tFailure = ServerFailure(message: 'Failed to load order details');

  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  setUp(() {
    mockOrderDetailsCubit = MockOrderDetailsCubit();
    when(
      () => mockOrderDetailsCubit.state,
    ).thenReturn(const OrderDetailsInitial());
    when(
      () => mockOrderDetailsCubit.fetchOrderDetails(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockOrderDetailsCubit.cancelOrder(any()),
    ).thenAnswer((_) async {});
  });

  Widget buildSubject({int orderId = 7}) {
    return BlocProvider<OrderDetailsCubit>.value(
      value: mockOrderDetailsCubit,
      child: TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: OrderDetailsScreen(orderId: orderId),
        ),
      ),
    );
  }

  group('OrderDetailsScreen UI states', () {
    testWidgets('shows loading indicator on initial state', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(OrderDetailsHeader), findsNothing);
    });

    testWidgets('shows loading indicator on loading state', (tester) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(const OrderDetailsLoading());

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(RemoteDataFailureView), findsNothing);
    });

    testWidgets('shows failure view on failed state', (tester) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(OrderDetailsFailed(tFailure));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
      expect(find.text('Failed to load order details'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows order details on loaded state', (tester) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(const OrderDetailsLoaded(order: tOrder));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(OrderDetailsHeader), findsOneWidget);
      expect(find.byType(OrderDetailsAddresses), findsOneWidget);
      expect(find.byType(OrderDetailsItemCard), findsOneWidget);
      expect(find.byType(OrderDetailsSummary), findsOneWidget);
      expect(find.text('#7'), findsOneWidget);
      expect(find.text('Cairo, Egypt'), findsOneWidget);
      expect(find.text('Mechanical Keyboard'), findsOneWidget);
      expect(find.text(r'$349.99'), findsOneWidget);
    });

    testWidgets('does not show cancel action for delivered orders', (
      tester,
    ) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(const OrderDetailsLoaded(order: tReplacementOrder));

      await tester.pumpWidget(buildSubject(orderId: 8));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Cancel Order'), findsNothing);
      expect(find.text('Delivered'), findsOneWidget);
    });

    testWidgets('shows cancellation progress while order is cancelling', (
      tester,
    ) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(const OrderDetailsLoaded(order: tOrder, isCancelling: true));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isFalse,
      );
    });
  });

  group('OrderDetailsScreen cubit integration', () {
    testWidgets('rebuilds through loading success and failure states', (
      tester,
    ) async {
      final controller = StreamController<OrderDetailsState>();
      addTearDown(controller.close);
      whenListen(
        mockOrderDetailsCubit,
        controller.stream,
        initialState: const OrderDetailsLoading(),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      controller.add(const OrderDetailsLoaded(order: tOrder));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('#7'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      controller.add(OrderDetailsFailed(tFailure));
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
      expect(find.text('#7'), findsNothing);

      controller.add(const OrderDetailsLoaded(order: tReplacementOrder));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('#8'), findsOneWidget);
      expect(find.text('#7'), findsNothing);
      expect(find.byType(RemoteDataFailureView), findsNothing);
    });
  });

  group('OrderDetailsScreen user interactions', () {
    testWidgets('calls fetchOrderDetails when retry button is tapped', (
      tester,
    ) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(OrderDetailsFailed(tFailure));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      verify(() => mockOrderDetailsCubit.fetchOrderDetails(7)).called(1);
    });

    testWidgets('opens cancel dialog and confirms cancellation', (
      tester,
    ) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(const OrderDetailsLoaded(order: tOrder));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Cancel Order'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CancelOrderDialog), findsOneWidget);
      expect(
        find.text('Are you sure you want to cancel this order?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Yes, Cancel Order'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      verify(() => mockOrderDetailsCubit.cancelOrder(7)).called(1);
      expect(find.byType(CancelOrderDialog), findsNothing);
    });

    testWidgets('dismisses cancel dialog without cancelling', (tester) async {
      when(
        () => mockOrderDetailsCubit.state,
      ).thenReturn(const OrderDetailsLoaded(order: tOrder));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Cancel Order'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('No, Keep It'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      verifyNever(() => mockOrderDetailsCubit.cancelOrder(any()));
      expect(find.byType(CancelOrderDialog), findsNothing);
    });
  });
}

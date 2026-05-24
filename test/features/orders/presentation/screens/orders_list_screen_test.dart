import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/widgets/no_results_found_view.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_state.dart';
import 'package:tech_nest/features/orders/presentation/screens/orders_list_screen.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_list_item.dart';
import 'package:tech_nest/features/orders/presentation/widgets/orders_list_loaded_view.dart';
import 'package:tech_nest/features/orders/presentation/widgets/orders_skeleton_list.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockOrdersListCubit extends MockCubit<OrdersListState>
    implements OrdersListCubit {}

void main() {
  late MockOrdersListCubit mockOrdersListCubit;

  const tOrders = [
    OrderEntity(
      id: 7,
      totalPrice: 349.99,
      status: OrderStatus.pending,
      createdAt: '2026-05-20T10:00:00Z',
      updatedAt: '2026-05-21T10:00:00Z',
    ),
    OrderEntity(
      id: 8,
      totalPrice: 120,
      status: OrderStatus.delivered,
      createdAt: '2026-05-22T10:00:00Z',
      updatedAt: '2026-05-23T10:00:00Z',
    ),
  ];

  final tFailure = ServerFailure(message: 'Failed to load orders');

  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  setUp(() {
    mockOrdersListCubit = MockOrdersListCubit();
    when(() => mockOrdersListCubit.state).thenReturn(const OrdersListInitial());
    when(() => mockOrdersListCubit.fetchOrders()).thenAnswer((_) async {});
  });

  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OrdersListScreen(),
        ),
        GoRoute(
          path: '/orderDetails',
          name: RouteNames.orderDetails,
          builder: (context, state) {
            final id = state.uri.queryParameters['orderId'];
            return Scaffold(body: Text('details:$id'));
          },
        ),
      ],
    );

    return BlocProvider<OrdersListCubit>.value(
      value: mockOrdersListCubit,
      child: TranslationProvider(
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: router,
        ),
      ),
    );
  }

  group('OrdersListScreen UI states', () {
    testWidgets('shows skeleton list on initial state', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(OrdersSkeletonList), findsOneWidget);
      expect(find.byType(OrdersListLoadedView), findsNothing);
      expect(find.byType(RemoteDataFailureView), findsNothing);
    });

    testWidgets('shows skeleton list on loading state', (tester) async {
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(const OrdersListLoading());

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(OrdersSkeletonList), findsOneWidget);
      expect(find.byType(OrderListItem), findsNothing);
    });

    testWidgets('shows failure view on failed state', (tester) async {
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(OrdersListFailed(tFailure));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
      expect(find.text('Failed to load orders'), findsOneWidget);
      expect(find.byType(OrdersSkeletonList), findsNothing);
    });

    testWidgets('shows empty state when loaded orders list is empty', (
      tester,
    ) async {
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(const OrdersListLoaded([]));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(NoResultsFoundView), findsOneWidget);
      expect(find.text('No Orders Found'), findsOneWidget);
      expect(find.byType(OrderListItem), findsNothing);
    });

    testWidgets('shows order list items when loaded orders list has data', (
      tester,
    ) async {
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(const OrdersListLoaded(tOrders));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(OrdersListLoadedView), findsOneWidget);
      expect(find.byType(OrderListItem), findsNWidgets(2));
      expect(find.text('#7'), findsOneWidget);
      expect(find.text('#8'), findsOneWidget);
      expect(find.text(r'$349.99'), findsOneWidget);
      expect(find.text(r'$120.00'), findsOneWidget);
      expect(find.byType(OrdersSkeletonList), findsNothing);
    });
  });

  group('OrdersListScreen cubit integration', () {
    testWidgets('rebuilds on consecutive state changes without stale widgets', (
      tester,
    ) async {
      final controller = StreamController<OrdersListState>();
      addTearDown(controller.close);
      whenListen(
        mockOrdersListCubit,
        controller.stream,
        initialState: const OrdersListInitial(),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(OrdersSkeletonList), findsOneWidget);

      controller.add(const OrdersListLoaded(tOrders));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(OrderListItem), findsNWidgets(2));
      expect(find.byType(OrdersSkeletonList), findsNothing);

      controller.add(OrdersListFailed(tFailure));
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
      expect(find.byType(OrderListItem), findsNothing);
      expect(find.byType(OrdersSkeletonList), findsNothing);

      controller.add(const OrdersListLoaded([]));
      await tester.pump();

      expect(find.byType(NoResultsFoundView), findsOneWidget);
      expect(find.byType(RemoteDataFailureView), findsNothing);
      expect(find.byType(OrderListItem), findsNothing);
    });

    testWidgets('keeps loading UI visible during slow state transition', (
      tester,
    ) async {
      final controller = StreamController<OrdersListState>();
      addTearDown(controller.close);
      whenListen(
        mockOrdersListCubit,
        controller.stream,
        initialState: const OrdersListLoading(),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(OrdersSkeletonList), findsOneWidget);

      controller.add(const OrdersListLoaded(tOrders));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(OrderListItem), findsNWidgets(2));
      expect(find.byType(OrdersSkeletonList), findsNothing);
    });
  });

  group('OrdersListScreen user interactions', () {
    testWidgets('calls fetchOrders when retry button is tapped', (
      tester,
    ) async {
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(OrdersListFailed(tFailure));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      verify(() => mockOrdersListCubit.fetchOrders()).called(1);
    });

    testWidgets('calls fetchOrders when empty state refresh is tapped', (
      tester,
    ) async {
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(const OrdersListLoaded([]));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      verify(() => mockOrdersListCubit.fetchOrders()).called(1);
    });

    testWidgets('calls fetchOrders on pull to refresh', (tester) async {
      final manyOrders = List<OrderEntity>.generate(
        12,
        (index) => OrderEntity(
          id: index + 1,
          totalPrice: (100 + index).toDouble(),
          status: OrderStatus.pending,
          createdAt: '2026-05-20T10:00:00Z',
          updatedAt: '2026-05-21T10:00:00Z',
        ),
      );
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(OrdersListLoaded(manyOrders));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockOrdersListCubit.fetchOrders()).called(1);
    });

    testWidgets('navigates to order details when an order item is tapped', (
      tester,
    ) async {
      when(
        () => mockOrdersListCubit.state,
      ).thenReturn(const OrdersListLoaded(tOrders));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('#7'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('details:7'), findsOneWidget);
    });
  });
}

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/widgets/loading_indicator.dart';
import 'package:tech_nest/core/widgets/no_results_found_view.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';
import 'package:tech_nest/features/notifications/presentation/notification_cubit/notification_cubit.dart';
import 'package:tech_nest/features/notifications/presentation/screens/notification_screen.dart';
import 'package:tech_nest/features/notifications/presentation/widgets/notification_item.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockNotificationCubit extends MockCubit<NotificationState>
    implements NotificationCubit {}

void main() {
  late MockNotificationCubit mockNotificationCubit;

  NotificationEntity buildNotification(int id, {bool isRead = false}) {
    return NotificationEntity(
      id: id,
      title: 'Notification $id',
      body: 'Body $id',
      type: 'ORDER',
      data: const {},
      createdAt: DateTime.parse('2026-05-20T10:00:00Z'),
      isRead: isRead,
    );
  }

  final tFailure = ServerFailure(message: 'Failed to load notifications');
  final tNotifications = [buildNotification(1), buildNotification(2, isRead: true)];

  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  setUp(() {
    mockNotificationCubit = MockNotificationCubit();
    when(() => mockNotificationCubit.state).thenReturn(const NotificationInitial());
    when(() => mockNotificationCubit.initialFetching()).thenAnswer((_) async {});
    when(() => mockNotificationCubit.fetchMore()).thenAnswer((_) async {});
    when(() => mockNotificationCubit.markAllAsRead()).thenAnswer((_) async {});
    when(() => mockNotificationCubit.markAsRead(any())).thenAnswer((_) async {});
  });

  Widget buildSubject() {
    return BlocProvider<NotificationCubit>.value(
      value: mockNotificationCubit,
      child: TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const NotificationScreen(),
        ),
      ),
    );
  }

  group('NotificationScreen UI states', () {
    testWidgets('shows loading indicator on initial state', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(NotificationItem), findsNothing);
      expect(find.byType(RemoteDataFailureView), findsNothing);
    });

    testWidgets('shows loading indicator on loading state', (tester) async {
      when(() => mockNotificationCubit.state).thenReturn(const NotificationLoading());

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(NotificationItem), findsNothing);
    });

    testWidgets('shows failure view on error state', (tester) async {
      when(() => mockNotificationCubit.state).thenReturn(NotificationError(tFailure));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
      expect(find.text('Failed to load notifications'), findsOneWidget);
      expect(find.byType(NotificationItem), findsNothing);
    });

    testWidgets('shows empty state when notifications are empty', (tester) async {
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        const NotificationLoaded(
          notifications: [],
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(NoResultsFoundView), findsOneWidget);
      expect(find.text("You don't have any notifications yet."), findsOneWidget);
      expect(find.byType(NotificationItem), findsNothing);
    });

    testWidgets('shows notifications list on loaded state', (tester) async {
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        NotificationLoaded(
          notifications: tNotifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(NotificationItem), findsNWidgets(2));
      expect(find.byType(RemoteDataFailureView), findsNothing);
    });

    testWidgets('shows load more failure widget when load more fails', (tester) async {
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        NotificationLoaded(
          notifications: tNotifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: tFailure,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
      expect(find.byType(NotificationItem), findsNWidgets(2));
    });

    testWidgets('shows mark all loading indicator while marking all as read', (tester) async {
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        NotificationLoaded(
          notifications: tNotifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
          isMarkingAllAsRead: true,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });
  });

  group('NotificationScreen cubit integration', () {
    testWidgets('rebuilds correctly from loading to loaded to error', (tester) async {
      final controller = StreamController<NotificationState>();
      addTearDown(controller.close);
      whenListen(
        mockNotificationCubit,
        controller.stream,
        initialState: const NotificationLoading(),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      controller.add(
        NotificationLoaded(
          notifications: tNotifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );
      await tester.pump();

      expect(find.byType(NotificationItem), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNothing);

      controller.add(NotificationError(tFailure));
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
      expect(find.byType(NotificationItem), findsNothing);
    });

    testWidgets('keeps loading state visible during slow transitions', (tester) async {
      final controller = StreamController<NotificationState>();
      addTearDown(controller.close);
      whenListen(
        mockNotificationCubit,
        controller.stream,
        initialState: const NotificationLoading(),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      controller.add(
        NotificationLoaded(
          notifications: tNotifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );
      await tester.pump();

      expect(find.byType(NotificationItem), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

  });

  group('NotificationScreen user interactions', () {
    testWidgets('calls initialFetching when retry button is tapped', (tester) async {
      when(() => mockNotificationCubit.state).thenReturn(NotificationError(tFailure));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      verify(() => mockNotificationCubit.initialFetching()).called(1);
    });

    testWidgets('calls initialFetching when empty-state refresh is tapped', (tester) async {
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        const NotificationLoaded(
          notifications: [],
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      verify(() => mockNotificationCubit.initialFetching()).called(1);
    });

    testWidgets('calls initialFetching on pull to refresh', (tester) async {
      final longList = List<NotificationEntity>.generate(
        12,
        (index) => buildNotification(index + 1, isRead: index.isEven),
      );
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        NotificationLoaded(
          notifications: longList,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.drag(find.byType(CustomScrollView), const Offset(0, 500));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockNotificationCubit.initialFetching()).called(1);
    });

    testWidgets('calls fetchMore when scrolled near bottom', (tester) async {
      final longList = List<NotificationEntity>.generate(
        25,
        (index) => buildNotification(index + 1, isRead: index.isOdd),
      );
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        NotificationLoaded(
          notifications: longList,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      verify(() => mockNotificationCubit.fetchMore()).called(1);
    });

    testWidgets('calls markAllAsRead when app bar action is tapped', (tester) async {
      when(
        () => mockNotificationCubit.state,
      ).thenReturn(
        NotificationLoaded(
          notifications: tNotifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final appBarIcon = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.mark_email_read_rounded),
      );

      await tester.tap(appBarIcon);
      await tester.pump();

      verify(() => mockNotificationCubit.markAllAsRead()).called(1);
    });

    testWidgets('shows snackbar when mark all as read partially fails', (tester) async {
      final controller = StreamController<NotificationState>();
      addTearDown(controller.close);
      final firstLoaded = NotificationLoaded(
        notifications: tNotifications,
        hasReachedMax: false,
        isLoadingMore: false,
        loadMoreFailure: null,
      );
      final failedLoaded = NotificationLoaded(
        notifications: tNotifications,
        hasReachedMax: false,
        isLoadingMore: false,
        loadMoreFailure: null,
        isMarkingAllAsReadFailed: true,
      );

      whenListen(
        mockNotificationCubit,
        controller.stream,
        initialState: firstLoaded,
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      controller.add(failedLoaded);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text('Some notifications could not be marked as read.'),
        findsOneWidget,
      );
    });
  });
}

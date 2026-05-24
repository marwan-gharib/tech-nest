import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';
import 'package:tech_nest/features/notifications/presentation/notification_cubit/notification_cubit.dart';
import 'package:tech_nest/features/notifications/presentation/widgets/notification_item.dart';

class MockNotificationCubit extends MockCubit<NotificationState>
    implements NotificationCubit {}

void main() {
  late MockNotificationCubit mockNotificationCubit;

  NotificationEntity buildNotification({required bool isRead, String title = 'Order update', String body = 'Order shipped'}) {
    return NotificationEntity(
      id: 7,
      title: title,
      body: body,
      type: 'ORDER',
      data: const {},
      createdAt: DateTime.parse('2026-05-20T10:00:00Z'),
      isRead: isRead,
    );
  }

  setUp(() {
    mockNotificationCubit = MockNotificationCubit();
    when(() => mockNotificationCubit.state).thenReturn(const NotificationInitial());
    when(() => mockNotificationCubit.markAsRead(any())).thenAnswer((_) async {});
  });

  Widget buildSubject(NotificationEntity notification) {
    return BlocProvider<NotificationCubit>.value(
      value: mockNotificationCubit,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: Scaffold(body: NotificationItem(notification: notification)),
      ),
    );
  }

  group('NotificationItem UI', () {
    testWidgets('renders title and body', (tester) async {
      await tester.pumpWidget(buildSubject(buildNotification(isRead: false)));
      await tester.pump();

      expect(find.text('Order update'), findsOneWidget);
      expect(find.text('Order shipped'), findsOneWidget);
    });

    testWidgets('shows mark as read action when notification is unread', (tester) async {
      await tester.pumpWidget(buildSubject(buildNotification(isRead: false)));
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.mark_email_read_rounded), findsOneWidget);
    });

    testWidgets('hides mark as read action when notification is already read', (tester) async {
      await tester.pumpWidget(buildSubject(buildNotification(isRead: true)));
      await tester.pump();

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('renders safely with empty title and body values', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          buildNotification(isRead: false, title: '', body: ''),
        ),
      );
      await tester.pump();

      expect(find.byType(NotificationItem), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });
  });

  group('NotificationItem interactions', () {
    testWidgets('calls markAsRead when trailing action is tapped for unread notification', (tester) async {
      await tester.pumpWidget(buildSubject(buildNotification(isRead: false)));
      await tester.pump();

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      verify(() => mockNotificationCubit.markAsRead(7)).called(1);
    });

    testWidgets('calls markAsRead when tile is tapped for unread notification', (tester) async {
      await tester.pumpWidget(buildSubject(buildNotification(isRead: false)));
      await tester.pump();

      await tester.tap(find.text('Order update'));
      await tester.pump();

      verify(() => mockNotificationCubit.markAsRead(7)).called(1);
    });

    testWidgets('does not call markAsRead when tile is tapped for read notification', (tester) async {
      await tester.pumpWidget(buildSubject(buildNotification(isRead: true)));
      await tester.pump();

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      verifyNever(() => mockNotificationCubit.markAsRead(any()));
    });
  });
}

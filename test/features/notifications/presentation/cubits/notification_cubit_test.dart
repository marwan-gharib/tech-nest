import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';
import 'package:tech_nest/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:tech_nest/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:tech_nest/features/notifications/presentation/notification_cubit/notification_cubit.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockMarkNotificationReadUseCase extends Mock
    implements MarkNotificationReadUseCase {}

void main() {
  late NotificationCubit cubit;
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late MockMarkNotificationReadUseCase mockMarkNotificationReadUseCase;

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

  final tFailure = ServerFailure(message: 'Failed request');
  final tFirstPage = List<NotificationEntity>.generate(
    10,
    (index) => NotificationEntity(
      id: index + 1,
      title: 'Notification ${index + 1}',
      body: 'Body ${index + 1}',
      type: 'ORDER',
      data: const {},
      createdAt: DateTime.parse('2026-05-20T10:00:00Z'),
      isRead: false,
    ),
  );
  final tMorePage = [buildNotification(11), buildNotification(12)];

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    mockMarkNotificationReadUseCase = MockMarkNotificationReadUseCase();
    cubit = NotificationCubit(
      getNotificationsUseCase: mockGetNotificationsUseCase,
      markNotificationReadUseCase: mockMarkNotificationReadUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is NotificationInitial', () {
    expect(cubit.state, const NotificationInitial());
  });

  group('initialFetching', () {
    blocTest<NotificationCubit, NotificationState>(
      'emits Loading then Loaded when use case succeeds',
      build: () {
        when(
          () => mockGetNotificationsUseCase.call(page: 1),
        ).thenAnswer((_) async => ApiSuccess(tMorePage));
        return cubit;
      },
      act: (cubit) => cubit.initialFetching(),
      expect: () => [
        const NotificationLoading(),
        NotificationLoaded(
          notifications: tMorePage,
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      ],
      verify: (_) => verify(() => mockGetNotificationsUseCase.call(page: 1)).called(1),
    );

    blocTest<NotificationCubit, NotificationState>(
      'emits Loading then Error when use case fails',
      build: () {
        when(
          () => mockGetNotificationsUseCase.call(page: 1),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.initialFetching(),
      expect: () => [const NotificationLoading(), NotificationError(tFailure)],
      verify: (_) => verify(() => mockGetNotificationsUseCase.call(page: 1)).called(1),
    );

    blocTest<NotificationCubit, NotificationState>(
      'keeps state consistent after repeated calls',
      build: () {
        var calls = 0;
        when(() => mockGetNotificationsUseCase.call(page: 1)).thenAnswer((_) async {
          calls += 1;
          if (calls == 1) {
            return ApiSuccess([buildNotification(1)]);
          }
          return ApiSuccess([buildNotification(1), buildNotification(2)]);
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.initialFetching();
        await cubit.initialFetching();
      },
      expect: () => [
        const NotificationLoading(),
        NotificationLoaded(
          notifications: [buildNotification(1)],
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
        const NotificationLoading(),
        NotificationLoaded(
          notifications: [buildNotification(1), buildNotification(2)],
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      ],
      verify: (_) => verify(() => mockGetNotificationsUseCase.call(page: 1)).called(2),
    );

    blocTest<NotificationCubit, NotificationState>(
      'handles rapid consecutive calls and preserves final loaded state',
      build: () {
        when(
          () => mockGetNotificationsUseCase.call(page: 1),
        ).thenAnswer((_) async => ApiSuccess([buildNotification(1)]));
        return cubit;
      },
      act: (cubit) async {
        await Future.wait([cubit.initialFetching(), cubit.initialFetching()]);
      },
      expect: () => [
        const NotificationLoading(),
        NotificationLoaded(
          notifications: [buildNotification(1)],
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      ],
      verify: (_) => verify(() => mockGetNotificationsUseCase.call(page: 1)).called(2),
    );
  });

  group('fetchMore', () {
    final loadedSeed = NotificationLoaded(
      notifications: tFirstPage,
      hasReachedMax: false,
      isLoadingMore: false,
      loadMoreFailure: null,
    );

    blocTest<NotificationCubit, NotificationState>(
      'emits loading more then merged loaded state when use case succeeds',
      build: () {
        when(
          () => mockGetNotificationsUseCase.call(page: 2),
        ).thenAnswer((_) async => ApiSuccess(tMorePage));
        return cubit;
      },
      seed: () => loadedSeed,
      act: (cubit) => cubit.fetchMore(),
      expect: () => [
        NotificationLoaded(
          notifications: tFirstPage,
          hasReachedMax: false,
          isLoadingMore: true,
          loadMoreFailure: null,
        ),
        NotificationLoaded(
          notifications: [...tFirstPage, ...tMorePage],
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      ],
      verify: (_) => verify(() => mockGetNotificationsUseCase.call(page: 2)).called(1),
    );

    blocTest<NotificationCubit, NotificationState>(
      'emits loading more then load more failure when use case fails',
      build: () {
        when(
          () => mockGetNotificationsUseCase.call(page: 2),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      seed: () => loadedSeed,
      act: (cubit) => cubit.fetchMore(),
      expect: () => [
        NotificationLoaded(
          notifications: tFirstPage,
          hasReachedMax: false,
          isLoadingMore: true,
          loadMoreFailure: null,
        ),
        NotificationLoaded(
          notifications: tFirstPage,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: tFailure,
        ),
      ],
      verify: (_) => verify(() => mockGetNotificationsUseCase.call(page: 2)).called(1),
    );

    blocTest<NotificationCubit, NotificationState>(
      'rolls back page counter after failure and retries same page on next call',
      build: () {
        var calls = 0;
        when(() => mockGetNotificationsUseCase.call(page: 2)).thenAnswer((_) async {
          calls += 1;
          if (calls == 1) {
            return ApiFailure(tFailure);
          }
          return ApiSuccess(tMorePage);
        });
        return cubit;
      },
      seed: () => loadedSeed,
      act: (cubit) async {
        await cubit.fetchMore();
        await cubit.fetchMore();
      },
      expect: () => [
        NotificationLoaded(
          notifications: tFirstPage,
          hasReachedMax: false,
          isLoadingMore: true,
          loadMoreFailure: null,
        ),
        NotificationLoaded(
          notifications: tFirstPage,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: tFailure,
        ),
        NotificationLoaded(
          notifications: tFirstPage,
          hasReachedMax: false,
          isLoadingMore: true,
          loadMoreFailure: null,
        ),
        NotificationLoaded(
          notifications: [...tFirstPage, ...tMorePage],
          hasReachedMax: true,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      ],
      verify: (_) => verify(() => mockGetNotificationsUseCase.call(page: 2)).called(2),
    );

    blocTest<NotificationCubit, NotificationState>(
      'does not emit when current state is not loaded',
      build: () => cubit,
      act: (cubit) => cubit.fetchMore(),
      expect: () => <NotificationState>[],
      verify: (_) => verifyNever(() => mockGetNotificationsUseCase.call(page: any(named: 'page'))),
    );

    blocTest<NotificationCubit, NotificationState>(
      'does not emit when already loading more',
      build: () => cubit,
      seed: () => NotificationLoaded(
        notifications: tFirstPage,
        hasReachedMax: false,
        isLoadingMore: true,
        loadMoreFailure: null,
      ),
      act: (cubit) => cubit.fetchMore(),
      expect: () => <NotificationState>[],
      verify: (_) => verifyNever(() => mockGetNotificationsUseCase.call(page: any(named: 'page'))),
    );

    blocTest<NotificationCubit, NotificationState>(
      'does not emit when reached max',
      build: () => cubit,
      seed: () => NotificationLoaded(
        notifications: tFirstPage,
        hasReachedMax: true,
        isLoadingMore: false,
        loadMoreFailure: null,
      ),
      act: (cubit) => cubit.fetchMore(),
      expect: () => <NotificationState>[],
      verify: (_) => verifyNever(() => mockGetNotificationsUseCase.call(page: any(named: 'page'))),
    );
  });

  group('markAsRead', () {
    final loadedSeed = NotificationLoaded(
      notifications: [buildNotification(1), buildNotification(2, isRead: true)],
      hasReachedMax: false,
      isLoadingMore: false,
      loadMoreFailure: null,
    );

    blocTest<NotificationCubit, NotificationState>(
      'updates notification read status when use case succeeds',
      build: () {
        when(
          () => mockMarkNotificationReadUseCase.call(1),
        ).thenAnswer((_) async => const ApiSuccess(null));
        return cubit;
      },
      seed: () => loadedSeed,
      act: (cubit) => cubit.markAsRead(1),
      expect: () => [
        NotificationLoaded(
          notifications: [buildNotification(1, isRead: true), buildNotification(2, isRead: true)],
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      ],
      verify: (_) => verify(() => mockMarkNotificationReadUseCase.call(1)).called(1),
    );

    blocTest<NotificationCubit, NotificationState>(
      'emits NotificationError when use case fails',
      build: () {
        when(
          () => mockMarkNotificationReadUseCase.call(1),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      seed: () => loadedSeed,
      act: (cubit) => cubit.markAsRead(1),
      expect: () => [NotificationError(tFailure)],
      verify: (_) => verify(() => mockMarkNotificationReadUseCase.call(1)).called(1),
    );

    blocTest<NotificationCubit, NotificationState>(
      'does not emit when state is not loaded',
      build: () => cubit,
      act: (cubit) => cubit.markAsRead(1),
      expect: () => <NotificationState>[],
      verify: (_) => verifyNever(() => mockMarkNotificationReadUseCase.call(any())),
    );

    blocTest<NotificationCubit, NotificationState>(
      'does not emit when notification id does not exist',
      build: () {
        when(
          () => mockMarkNotificationReadUseCase.call(100),
        ).thenAnswer((_) async => const ApiSuccess(null));
        return cubit;
      },
      seed: () => loadedSeed,
      act: (cubit) => cubit.markAsRead(100),
      expect: () => <NotificationState>[],
      verify: (_) => verify(() => mockMarkNotificationReadUseCase.call(100)).called(1),
    );
  });

  group('markAllAsRead', () {
    final seedState = NotificationLoaded(
      notifications: [
        buildNotification(1, isRead: false),
        buildNotification(2, isRead: false),
        buildNotification(3, isRead: true),
      ],
      hasReachedMax: false,
      isLoadingMore: false,
      loadMoreFailure: null,
    );

    blocTest<NotificationCubit, NotificationState>(
      'marks all unread notifications as read when all requests succeed',
      build: () {
        when(
          () => mockMarkNotificationReadUseCase.call(1),
        ).thenAnswer((_) async => const ApiSuccess(null));
        when(
          () => mockMarkNotificationReadUseCase.call(2),
        ).thenAnswer((_) async => const ApiSuccess(null));
        return cubit;
      },
      seed: () => seedState,
      act: (cubit) => cubit.markAllAsRead(),
      expect: () => [
        NotificationLoaded(
          notifications: seedState.notifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
          isMarkingAllAsRead: true,
          isMarkingAllAsReadFailed: false,
        ),
        NotificationLoaded(
          notifications: [
            buildNotification(1, isRead: true),
            buildNotification(2, isRead: true),
            buildNotification(3, isRead: true),
          ],
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
          isMarkingAllAsRead: false,
          isMarkingAllAsReadFailed: false,
        ),
      ],
      verify: (_) {
        verify(() => mockMarkNotificationReadUseCase.call(1)).called(1);
        verify(() => mockMarkNotificationReadUseCase.call(2)).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'sets isMarkingAllAsReadFailed when some requests fail',
      build: () {
        when(
          () => mockMarkNotificationReadUseCase.call(1),
        ).thenAnswer((_) async => const ApiSuccess(null));
        when(
          () => mockMarkNotificationReadUseCase.call(2),
        ).thenAnswer((_) async => ApiFailure(tFailure));
        return cubit;
      },
      seed: () => seedState,
      act: (cubit) => cubit.markAllAsRead(),
      expect: () => [
        NotificationLoaded(
          notifications: seedState.notifications,
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
          isMarkingAllAsRead: true,
          isMarkingAllAsReadFailed: false,
        ),
        NotificationLoaded(
          notifications: [
            buildNotification(1, isRead: true),
            buildNotification(2, isRead: false),
            buildNotification(3, isRead: true),
          ],
          hasReachedMax: false,
          isLoadingMore: false,
          loadMoreFailure: null,
          isMarkingAllAsRead: false,
          isMarkingAllAsReadFailed: true,
        ),
      ],
      verify: (_) {
        verify(() => mockMarkNotificationReadUseCase.call(1)).called(1);
        verify(() => mockMarkNotificationReadUseCase.call(2)).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'does not emit when state is not loaded',
      build: () => cubit,
      act: (cubit) => cubit.markAllAsRead(),
      expect: () => <NotificationState>[],
      verify: (_) => verifyNever(() => mockMarkNotificationReadUseCase.call(any())),
    );
  });
}

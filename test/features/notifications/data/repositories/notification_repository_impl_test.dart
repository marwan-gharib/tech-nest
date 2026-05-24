import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tech_nest/features/notifications/data/models/notification_model.dart';
import 'package:tech_nest/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';

class MockNotificationRemoteDataSource extends Mock
    implements NotificationRemoteDataSource {}

void main() {
  late NotificationRepositoryImpl repository;
  late MockNotificationRemoteDataSource mockRemoteDataSource;

  final tNotificationModel = NotificationModel(
    id: 1,
    title: 'Order update',
    body: 'Your order has shipped',
    type: 'ORDER',
    data: const {'id': 10},
    createdAt: DateTime.parse('2026-05-20T10:00:00Z'),
    isRead: false,
  );

  setUp(() {
    mockRemoteDataSource = MockNotificationRemoteDataSource();
    repository = NotificationRepositoryImpl(mockRemoteDataSource);
  });

  group('getNotifications', () {
    test(
      'returns ApiSuccess with mapped entities and passes page parameter',
      () async {
        when(
          () => mockRemoteDataSource.getNotifications(page: 2),
        ).thenAnswer((_) async => [tNotificationModel]);

        final result = await repository.getNotifications(page: 2);

        expect(result, isA<ApiSuccess<List<NotificationEntity>>>());
        result.fold((_) => fail('Expected success'), (data) {
          expect(data, [tNotificationModel.toEntity()]);
        });
        verify(() => mockRemoteDataSource.getNotifications(page: 2)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test('returns ServerFailure when remote data source throws ServerException', () async {
      when(
        () => mockRemoteDataSource.getNotifications(page: 1),
      ).thenThrow(ServerException('Server failed', activeToUser: true));

      final result = await repository.getNotifications();

      expect(result, isA<ApiFailure<List<NotificationEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server failed');
        },
        (_) => fail('Expected failure'),
      );
    });

    test('returns NetworkFailure when remote data source throws NetworkException', () async {
      when(
        () => mockRemoteDataSource.getNotifications(page: 1),
      ).thenThrow(NetworkException());

      final result = await repository.getNotifications();

      expect(result, isA<ApiFailure<List<NotificationEntity>>>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('returns UnknownFailure when remote data source throws unexpected exception', () async {
      when(
        () => mockRemoteDataSource.getNotifications(page: 1),
      ).thenThrow(Exception('Unexpected'));

      final result = await repository.getNotifications();

      expect(result, isA<ApiFailure<List<NotificationEntity>>>());
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('markAsRead', () {
    test('calls remote data source with notification id and returns ApiSuccess', () async {
      when(() => mockRemoteDataSource.markAsRead(15)).thenAnswer((_) async {});

      final result = await repository.markAsRead(15);

      expect(result, isA<ApiSuccess<void>>());
      verify(() => mockRemoteDataSource.markAsRead(15)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('returns ServerFailure when remote data source throws ServerException', () async {
      when(
        () => mockRemoteDataSource.markAsRead(15),
      ).thenThrow(ServerException('Unable to mark as read', activeToUser: true));

      final result = await repository.markAsRead(15);

      expect(result, isA<ApiFailure<void>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Unable to mark as read');
        },
        (_) => fail('Expected failure'),
      );
    });

    test('returns UnknownFailure when remote data source throws unexpected exception', () async {
      when(() => mockRemoteDataSource.markAsRead(15)).thenThrow(StateError('Unexpected'));

      final result = await repository.markAsRead(15);

      expect(result, isA<ApiFailure<void>>());
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('saveFCMToken', () {
    test('calls remote data source with token and returns ApiSuccess', () async {
      when(
        () => mockRemoteDataSource.saveFCMToken('fcm-token'),
      ).thenAnswer((_) async {});

      final result = await repository.saveFCMToken('fcm-token');

      expect(result, isA<ApiSuccess<void>>());
      verify(() => mockRemoteDataSource.saveFCMToken('fcm-token')).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('returns NetworkFailure when remote data source throws NetworkException', () async {
      when(
        () => mockRemoteDataSource.saveFCMToken('fcm-token'),
      ).thenThrow(NetworkException());

      final result = await repository.saveFCMToken('fcm-token');

      expect(result, isA<ApiFailure<void>>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('returns UnknownFailure when remote data source throws unexpected exception', () async {
      when(
        () => mockRemoteDataSource.saveFCMToken('fcm-token'),
      ).thenThrow(Exception('Unexpected'));

      final result = await repository.saveFCMToken('fcm-token');

      expect(result, isA<ApiFailure<void>>());
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });
}

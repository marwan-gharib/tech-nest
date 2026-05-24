import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tech_nest/features/notifications/data/models/notification_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late NotificationRemoteDataSource dataSource;
  late MockApiClient mockApiClient;

  final tNotificationJson = {
    ApiKeys.id: 1,
    ApiKeys.title: 'Order update',
    ApiKeys.body: 'Order shipped',
    ApiKeys.type: 'ORDER',
    ApiKeys.data: {ApiKeys.id: 11},
    ApiKeys.createdAt: '2026-05-20T10:00:00Z',
    ApiKeys.isRead: 0,
  };

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = NotificationRemoteDataSource(mockApiClient);
  });

  group('getNotifications', () {
    test(
      'returns NotificationModel list when response contains notifications',
      () async {
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => {
            ApiKeys.data: {
              ApiKeys.notifications: [tNotificationJson],
            },
          },
        );

        final result = await dataSource.getNotifications(page: 2);

        expect(result, isA<List<NotificationModel>>());
        expect(result, hasLength(1));
        expect(result.first.id, 1);
        expect(result.first.title, 'Order update');
        verify(
          () => mockApiClient.get(
            Endpoints.listNotifications,
            queryParameters: {ApiKeys.page: 2},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('returns empty list when response is null', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => null);

      final result = await dataSource.getNotifications();

      expect(result, isEmpty);
    });

    test('returns empty list when notifications payload shape is invalid', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => {
          ApiKeys.data: {ApiKeys.notifications: {'id': 1}},
        },
      );

      final result = await dataSource.getNotifications();

      expect(result, isEmpty);
    });

    test('rethrows AppException from ApiClient', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(ServerException('Server error'));

      expect(
        () => dataSource.getNotifications(),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws UnKnownException when notification JSON is invalid', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => {
          ApiKeys.data: {
            ApiKeys.notifications: [
              {ApiKeys.id: 'invalid'},
            ],
          },
        },
      );

      expect(
        () => dataSource.getNotifications(),
        throwsA(isA<UnKnownException>()),
      );
    });

    test('throws UnKnownException when ApiClient throws generic exception', () async {
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(Exception('Unexpected'));

      expect(
        () => dataSource.getNotifications(),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('markAsRead', () {
    test('calls mark notification as read endpoint with notification id', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => null);

      await dataSource.markAsRead(55);

      verify(
        () => mockApiClient.post(
          Endpoints.markNotificationAsRead,
          data: {ApiKeys.notificationId: 55},
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('rethrows AppException from ApiClient', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenThrow(NetworkException());

      expect(
        () => dataSource.markAsRead(55),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws UnKnownException when ApiClient throws generic exception', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenThrow(Exception('Unexpected'));

      expect(
        () => dataSource.markAsRead(55),
        throwsA(isA<UnKnownException>()),
      );
    });
  });

  group('saveFCMToken', () {
    test('calls save token endpoint with fcm token', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => null);

      await dataSource.saveFCMToken('token-123');

      verify(
        () => mockApiClient.post(
          Endpoints.saveFCMToken,
          data: {ApiKeys.fcmToken: 'token-123'},
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('rethrows AppException from ApiClient', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenThrow(ServerException('Server error'));

      expect(
        () => dataSource.saveFCMToken('token-123'),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws UnKnownException when ApiClient throws generic exception', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenThrow(Exception('Unexpected'));

      expect(
        () => dataSource.saveFCMToken('token-123'),
        throwsA(isA<UnKnownException>()),
      );
    });
  });
}

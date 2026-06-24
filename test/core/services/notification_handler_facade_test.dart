import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/routing/deep_link_router.dart';
import 'package:tech_nest/core/services/notification_handler_facade.dart';

class MockDeepLinkRouter extends Mock implements DeepLinkRouter {}
class MockRemoteMessage extends Mock implements RemoteMessage {}

void main() {
  late MockDeepLinkRouter mockDeepLinkRouter;
  late NotificationHandlerFacade facade;

  setUp(() {
    mockDeepLinkRouter = MockDeepLinkRouter();
    facade = NotificationHandlerFacade(
      deepLinkRouter: mockDeepLinkRouter,
    );
  });

  group('NotificationHandlerFacade', () {
    test('handleInitialMessage extracts route and navigates', () {
      final mockMessage = MockRemoteMessage();
      when(() => mockMessage.data).thenReturn({'route': '/order/1234'});

      facade.handleInitialMessage(mockMessage);

      verify(() => mockDeepLinkRouter.navigate('/order/1234')).called(1);
    });

    test('handleInitialMessage ignores if no route', () {
      final mockMessage = MockRemoteMessage();
      when(() => mockMessage.data).thenReturn({'other_key': 'value'});

      facade.handleInitialMessage(mockMessage);

      verifyNever(() => mockDeepLinkRouter.navigate(any()));
    });

    test('handleInitialMessage ignores if message is null', () {
      facade.handleInitialMessage(null);
      verifyNever(() => mockDeepLinkRouter.navigate(any()));
    });
  });
}

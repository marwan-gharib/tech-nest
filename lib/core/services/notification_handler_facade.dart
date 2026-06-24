import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tech_nest/core/routing/deep_link_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/utils/logger.dart';

/// Facade for handling FCM notifications and delegating routing
class NotificationHandlerFacade {
  final DeepLinkRouter _deepLinkRouter;

  NotificationHandlerFacade({required DeepLinkRouter deepLinkRouter})
    : _deepLinkRouter = deepLinkRouter;

  Future<void> initialize() async {
    // Handle Background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    AppLogger.info('Received Background Message: ${message.data}');
    final route = _extractRoute(message);
    if (route != null) {
      _deepLinkRouter.navigate(route);
    }
  }

  void handleInitialMessage(RemoteMessage? message) {
    if (message != null) {
      AppLogger.info('Received Initial Message: ${message.data}');
      final route = _extractRoute(message);
      if (route != null) {
        _deepLinkRouter.navigate(RoutePaths.home, isGo: true);
        _deepLinkRouter.navigate(route);
      }
    }
  }

  String? _extractRoute(RemoteMessage message) {
    if (message.data.containsKey('route')) {
      final route = message.data['route'];
      if (route is String && route.isNotEmpty) {
        return route;
      }
    }
    return null;
  }
}

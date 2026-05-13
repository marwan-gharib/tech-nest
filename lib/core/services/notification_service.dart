import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/services/local_notification_service.dart';
import 'package:tech_nest/core/utils/fcm_background_handler.dart';
import 'package:tech_nest/core/utils/handle_notification.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/features/notifications/domain/usecases/save_fcm_token_usecase.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final LocalNotificationService _localNotifications;
  final CacheService _cacheService;
  final AuthNotifier _authNotifier;
  final SaveFCMTokenUseCase _saveFCMTokenUseCase;

  bool _initialized = false;

  NotificationService({
    required LocalNotificationService localNotifications,
    required CacheService cacheService,
    required AuthNotifier authNotifier,
    required SaveFCMTokenUseCase saveFCMTokenUseCase,
  }) : _localNotifications = localNotifications,
       _cacheService = cacheService,
       _authNotifier = authNotifier,
       _saveFCMTokenUseCase = saveFCMTokenUseCase;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _fcm.subscribeToTopic("all_users");

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermissions();

    await _localNotifications.initialize();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      AppLogger.info('Notification tapped (background): ${message.data}');
      HandleNotification.handle(message.data);
    });

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      AppLogger.info(
        'Notification tapped (terminated): ${initialMessage.messageId}',
      );
      HandleNotification.handle(initialMessage.data);
    }

    await _setupTokenLifecycle();
    _authNotifier.addListener(_onAuthStateChanged);
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        AppLogger.info('FCM: permission granted');
      case AuthorizationStatus.provisional:
        AppLogger.info('FCM: provisional permission granted');
      case AuthorizationStatus.denied:
      case AuthorizationStatus.notDetermined:
        AppLogger.warning('FCM: permission not granted');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    AppLogger.info('FCM: Message data: ${message.data}');
    final notification = message.notification;
    if (notification != null) {
      _localNotifications.showNotification(
        id: message.hashCode,
        title: notification.title ?? '',
        body: notification.body ?? '',
        data: message.data,
      );
    }
  }

  Future<void> _setupTokenLifecycle() async {
    try {
      final String? token = await _fcm.getToken();
      if (token != null) {
        AppLogger.info('FCM token: $token');
        await _handleNewToken(token);
      }
    } catch (e) {
      AppLogger.warning(
        'FCM getToken() failed — push notifications unavailable on this device: $e',
      );
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      AppLogger.info('FCM token refreshed');
      await _handleNewToken(newToken);
    }, onError: (e) => AppLogger.error('FCM onTokenRefresh stream error: $e'));
  }

  Future<void> _handleNewToken(String token) async {
    if (_authNotifier.isAuth) {
      await _sendTokenToBackend(token);
      await _cacheService.remove(AppConstants.fcmTokenCacheKey);
    } else {
      AppLogger.info('FCM: user not logged in — caching token locally');
      await _cacheService.setData(
        key: AppConstants.fcmTokenCacheKey,
        value: token,
      );
    }
  }

  void _onAuthStateChanged() {
    if (_authNotifier.isAuth) {
      final cachedToken =
          _cacheService.get(AppConstants.fcmTokenCacheKey) as String?;
      if (cachedToken == null) return;

      AppLogger.info('FCM: user logged in — flushing cached token to backend');
      _sendTokenToBackend(cachedToken).then((_) {
        _cacheService.remove(AppConstants.fcmTokenCacheKey);
      });
    } else {
      _cacheService.remove(AppConstants.fcmTokenCacheKey);
      AppLogger.info('FCM: user logged out — cached token cleared');
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    final result = await _saveFCMTokenUseCase.call(token);
    result.fold(
      (failure) =>
          AppLogger.error('FCM: failed to send token — ${failure.message}'),
      (_) => AppLogger.info('FCM: token sent to backend successfully'),
    );
  }

  void dispose() {
    _authNotifier.removeListener(_onAuthStateChanged);
  }
}

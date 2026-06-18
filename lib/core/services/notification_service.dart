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
  bool _isInitializing = false;

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
    if (_initialized || _isInitializing) return;
    _isInitializing = true;

    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _localNotifications.initialize();

      await _requestPermissions();

      await _subscribeToGlobalTopic();

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        HandleNotification.handle(message.data);
      });

      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        HandleNotification.handle(initialMessage.data);
      }

      await _setupTokenLifecycle();
      _authNotifier.addListener(_onAuthStateChanged);
      _initialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _subscribeToGlobalTopic() async {
    try {
      await _fcm.subscribeToTopic('all_users');
    } catch (e) {
      AppLogger.warning(
        'FCM topic subscription failed; continuing without topic sync: $e',
      );
    }
  }

  Future<void> _requestPermissions() async {
    await _localNotifications.requestPermission();

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
        await _handleNewToken(token);
      }
    } catch (e) {
      AppLogger.warning(
        'FCM getToken() failed — push notifications unavailable on this device: $e',
      );
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      await _handleNewToken(newToken);
    }, onError: (e) => AppLogger.error('FCM onTokenRefresh stream error: $e'));
  }

  Future<void> _handleNewToken(String token) async {
    if (_authNotifier.isAuth) {
      await _sendTokenToBackend(token);
      await _cacheService.remove(AppConstants.fcmTokenCacheKey);
    } else {
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

      _sendTokenToBackend(cachedToken).then((_) {
        _cacheService.remove(AppConstants.fcmTokenCacheKey);
      });
    } else {
      _cacheService.remove(AppConstants.fcmTokenCacheKey);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    await _saveFCMTokenUseCase.call(token);
  }

  void dispose() {
    _authNotifier.removeListener(_onAuthStateChanged);
  }
}

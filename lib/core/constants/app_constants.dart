class AppConstants {
  const AppConstants._();

  static String get skipAuth => "skipAuth";

  static String get themeKey => "themeMode";
  static String get localeKey => "app_locale";
  static String get onboardingKey => "has_seen_onboarding";

  static const String notificationChannelId = 'tech_nest_notifications';
  static const String notificationChannelName = 'Tech Nest Notifications';
  static const String notificationChannelDescription =
      'Main channel for app notifications';
  static const String notificationIcon = 'ic_notification';

  static const String orderDetailsId = 'orderId';
  static const String productDetailsId = 'productId';

  /// Key used to locally cache the FCM token before the user logs in.
  static const String fcmTokenCacheKey = 'pending_fcm_token';
}

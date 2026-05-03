import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tech_nest/core/utils/logger.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.info('Background message received: ${message.messageId}');
}

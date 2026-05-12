import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tech_nest/core/utils/handle_notification.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppLogger.info('Background message received: ${message.messageId}');

  HandleNotification.handle(message.data);
}

import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/notifications/data/models/notification_handler_model.dart';
import 'package:tech_nest/features/notifications/domain/handlers/notification_handler_factory.dart';

class HandleNotification {
  const HandleNotification._();

  static void handle(Map<String, dynamic>? data) {
    AppLogger.info('Notification data In Handler: $data');
    if (data == null) return;
    final model = NotificationHandlerModel.fromJson(data);
    final handler = NotificationHandlerFactory.getHandler(model.type);
    if (handler != null) {
      handler.handle(model);
    } else {
      AppLogger.info('Notification type not found: ${model.type}');
    }
  }
}

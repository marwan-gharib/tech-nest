import 'package:tech_nest/features/notifications/data/models/notification_handler_model.dart';

abstract class NotificationHandler {
  void handle(NotificationHandlerModel notificationHandlerModel);
}

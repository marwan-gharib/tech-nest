import 'package:tech_nest/core/constants/notification_types.dart';
import 'package:tech_nest/features/notifications/domain/handlers/new_product_notification_handler.dart';
import 'package:tech_nest/features/notifications/domain/handlers/notification_handler.dart';
import 'package:tech_nest/features/notifications/domain/handlers/order_notification_handler.dart';
import 'package:tech_nest/features/notifications/domain/handlers/reset_password_notification_handler.dart';

class NotificationHandlerFactory {
  const NotificationHandlerFactory._();

  static final Map<String, NotificationHandler> _handlers = {
    NotificationTypes.product: NewProductNotificationHandler(),
    NotificationTypes.order: OrderNotificationHandler(),
    NotificationTypes.resetPassword: ResetPasswordNotificationHandler(),
  };

  static NotificationHandler? getHandler(String type) {
    return _handlers[type.toUpperCase()];
  }
}

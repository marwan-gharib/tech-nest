import 'package:tech_nest/app/app_router.dart';
import 'package:tech_nest/features/notifications/data/models/notification_handler_model.dart';
import 'package:tech_nest/features/notifications/domain/handlers/notification_handler.dart';

class NewProductNotificationHandler extends NotificationHandler {
  @override
  void handle(NotificationHandlerModel notificationHandlerModel) {
    final productId = notificationHandlerModel.entityId;
    AppRouter.goToProductDetails(productId);
  }
}

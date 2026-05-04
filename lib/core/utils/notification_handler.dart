import 'package:tech_nest/app/app_router.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/utils/logger.dart';

class NotificationHandler {
  static void handleNotification(Map<String, dynamic> data) {
    AppLogger.info('Handling notification with data: $data');

    final type = data[ApiKeys.type] as String?;
    if (type == null) return;

    switch (type) {
      case ApiKeys.orderUpdate:
        final orderId = data[ApiKeys.orderId];
        if (orderId != null) {
          AppRouter.routes.pushNamed(RouteNames.orderDetails, extra: orderId);
        }
        break;
      case ApiKeys.promo:
        AppRouter.routes.goNamed(RouteNames.home);
        break;
      case ApiKeys.product:
        final productId = data[ApiKeys.productId];
        if (productId != null) {
          AppLogger.warning(
            'Product navigation from notification requires a ProductEntity or an ID-based route.',
          );
        }
        break;
      default:
        AppLogger.warning('Unknown notification type: $type');
        break;
    }
  }
}

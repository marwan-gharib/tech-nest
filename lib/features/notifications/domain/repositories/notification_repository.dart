import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<ApiResult<List<NotificationEntity>>> getNotifications({int page = 1});
  Future<ApiResult<void>> markAsRead(int notificationId);
  Future<ApiResult<void>> saveFCMToken(String token);
}

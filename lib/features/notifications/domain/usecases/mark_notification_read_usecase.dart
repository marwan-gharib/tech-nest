import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  Future<ApiResult<void>> call(int notificationId) {
    return _repository.markAsRead(notificationId);
  }
}

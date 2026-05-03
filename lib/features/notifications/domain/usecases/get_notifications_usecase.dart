import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';
import 'package:tech_nest/features/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<ApiResult<List<NotificationEntity>>> call({int page = 1}) {
    return _repository.getNotifications(page: page);
  }
}

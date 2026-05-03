import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/notifications/domain/repositories/notification_repository.dart';

class SaveFCMTokenUseCase {
  final NotificationRepository _repository;

  SaveFCMTokenUseCase(this._repository);

  Future<ApiResult<void>> call(String token) {
    return _repository.saveFCMToken(token);
  }
}

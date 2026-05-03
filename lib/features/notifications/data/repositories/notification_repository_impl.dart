import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';
import 'package:tech_nest/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<List<NotificationEntity>>> getNotifications({
    int page = 1,
  }) async {
    try {
      final list = await _remoteDataSource.getNotifications(page: page);
      final notifications = list.map((e) => e.toEntity()).toList();
      return ApiSuccess(notifications);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> markAsRead(int notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const ApiSuccess(null);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> saveFCMToken(String token) async {
    try {
      await _remoteDataSource.saveFCMToken(token);
      return const ApiSuccess(null);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }
}

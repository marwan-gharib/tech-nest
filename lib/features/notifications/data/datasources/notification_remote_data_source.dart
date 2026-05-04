import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/notifications/data/models/notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSource(this._apiClient);

  Future<List<NotificationModel>> getNotifications({int page = 1}) async {
    try {
      final response = await _apiClient.get(
        Endpoints.listNotifications,
        queryParameters: {ApiKeys.page: page},
      );

      if (response != null) {
        final data = response[ApiKeys.data];
        if (data is Map<String, dynamic> &&
            data[ApiKeys.notifications] is List) {
          return List<NotificationModel>.from(
            data[ApiKeys.notifications].map(
              (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
            ),
          );
        }
      }

      return [];
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiClient.post(
        Endpoints.markNotificationAsRead,
        data: {ApiKeys.notificationId: notificationId},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<void> saveFCMToken(String token) async {
    try {
      await _apiClient.post(
        Endpoints.saveFCMToken,
        data: {ApiKeys.fcmToken: token},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }
}

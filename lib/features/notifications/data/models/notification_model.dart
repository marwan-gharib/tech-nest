import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: int.parse(json[ApiKeys.id].toString()),
      title: json[ApiKeys.title] as String,
      body: json[ApiKeys.body] as String,
      type: json[ApiKeys.type] as String,
      data: json[ApiKeys.data] is Map
          ? json[ApiKeys.data] as Map<String, dynamic>
          : {},
      createdAt: DateTime.parse(json[ApiKeys.createdAt] as String),
      isRead: (json[ApiKeys.isRead] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.title: title,
      ApiKeys.body: body,
      ApiKeys.type: type,
      ApiKeys.data: data,
      ApiKeys.createdAt: createdAt.toIso8601String(),
      ApiKeys.isRead: isRead ? 1 : 0,
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      type: type,
      data: data,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}

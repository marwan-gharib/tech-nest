import 'dart:convert';

import 'package:tech_nest/core/constants/api_keys.dart';

class NotificationHandlerModel {
  final String type;
  final String entityType;
  final int entityId;

  NotificationHandlerModel({
    required this.type,
    required this.entityType,
    required this.entityId,
  });

  factory NotificationHandlerModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> entity = jsonDecode(json[ApiKeys.entity]) ?? {};
    return NotificationHandlerModel(
      type: json[ApiKeys.type] ?? '',
      entityType: entity[ApiKeys.type] ?? '',
      entityId: entity[ApiKeys.id] ?? 0,
    );
  }
}

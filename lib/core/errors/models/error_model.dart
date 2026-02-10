import 'package:tech_nest/core/constants/api_keys.dart';

class ErrorModel {
  final int statusCode;
  final String message;

  ErrorModel({required this.statusCode, required this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(statusCode: json[ApiKeys.status], message: json[ApiKeys.message]);
  }
}

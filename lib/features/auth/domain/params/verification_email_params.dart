import 'package:tech_nest/core/constants/api_keys.dart';

class VerificationEmailParams {
  final String email;
  final String code;

  VerificationEmailParams({required this.email, required this.code});

  Map<String, dynamic> toJson() {
    return {ApiKeys.email: email, ApiKeys.code: code};
  }
}

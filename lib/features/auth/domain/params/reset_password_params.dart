import 'package:tech_nest/core/constants/api_keys.dart';

class ResetPasswordParams {
  final String email;
  final String code;
  final String newPass;

  ResetPasswordParams({
    required this.email,
    required this.code,
    required this.newPass,
  });

  Map<String, dynamic> toJson() {
    return {ApiKeys.email: email, ApiKeys.code: code, ApiKeys.newPass: newPass};
  }
}

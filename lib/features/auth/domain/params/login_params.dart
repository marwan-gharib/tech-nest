import 'package:tech_nest/core/constants/api_keys.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
  Map<String, dynamic> toJson() {
    return {ApiKeys.email: email, ApiKeys.pass: password};
  }
}

import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/shared/data/models/user_model.dart';

class AuthModel {
  final String token;
  final UserModel userModel;

  AuthModel._({required this.token, required this.userModel});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel._(
      token: json[ApiKeys.token],
      userModel: UserModel.fromJson(json[ApiKeys.user]),
    );
  }

  Map<String, dynamic> toJson() {
    return {ApiKeys.token: token, ApiKeys.user: userModel.toJson()};
  }
}

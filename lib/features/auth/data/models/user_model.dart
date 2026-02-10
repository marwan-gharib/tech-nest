import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json[ApiKeys.id] as num).toInt(),
      name: json[ApiKeys.name],
      email: json[ApiKeys.email],
      token: json[ApiKeys.token],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.name: name,
      ApiKeys.email: email,
      ApiKeys.token: token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, email: email, token: token);
  }
}

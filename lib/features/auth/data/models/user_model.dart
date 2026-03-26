import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel._({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel._(
      id: int.parse(json[ApiKeys.id].toString()),
      name: json[ApiKeys.name],
      email: json[ApiKeys.email],
    );
  }

  Map<String, dynamic> toJson() {
    return {ApiKeys.id: id, ApiKeys.name: name, ApiKeys.email: email};
  }

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, email: email);
  }
}

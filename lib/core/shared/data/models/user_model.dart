import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/shared/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json[ApiKeys.id].toString()),
      name: json[ApiKeys.name] as String? ?? '',
      email: json[ApiKeys.email] as String? ?? '',
      image:
          json[ApiKeys.image] as String? ??
          json[ApiKeys.profileImgUrl] as String? ??
          json[ApiKeys.imgUrl] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.name: name,
      ApiKeys.email: email,
      ApiKeys.image: image,
    };
  }

  UserEntity toEntity() =>
      UserEntity(id: id, name: name, email: email, image: image);
}

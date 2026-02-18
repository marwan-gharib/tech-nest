import 'dart:io';

import 'package:tech_nest/core/constants/api_keys.dart';

class SignUpParams {
  final String name;
  final String email;
  final String password;
  final File img;

  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.img,
  });
  Map<String, dynamic> toJson() {
    return {ApiKeys.name: name, ApiKeys.email: email, ApiKeys.pass: password};
  }
}

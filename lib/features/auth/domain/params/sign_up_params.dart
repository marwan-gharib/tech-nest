import 'dart:io';

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
}

import 'dart:io';

class SocialLoginParams {
  final String email;
  final String name;
  final String provider;
  final String socialId;
  final File img;

  SocialLoginParams({
    required this.email,
    required this.name,
    required this.provider,
    required this.socialId,
    required this.img,
  });
}

class ResetPasswordParams {
  final String email;
  final String code;
  final String newPass;

  ResetPasswordParams({
    required this.email,
    required this.code,
    required this.newPass,
  });
}

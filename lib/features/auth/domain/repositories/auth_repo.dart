import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

abstract class AuthRepo {
  Future<User> signUp({required SignUpParams params});
  Future<User> login({required LoginParams params});
  Future<User> verifyEmail({required VerificationEmailParams params});
  Future<void> resetPassword({required ResetPasswordParams params});
  Future<void> forgetPassword({required String email});
  Future<void> logout();
}

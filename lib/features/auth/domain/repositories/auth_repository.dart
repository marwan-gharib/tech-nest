import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

abstract class AuthRepository {
  Future<ApiResult<UserEntity>> signUp({required SignUpParams params});
  Future<ApiResult<UserEntity>> login({required LoginParams params});
  Future<ApiResult<UserEntity>> verifyEmail({
    required VerificationEmailParams params,
  });
  Future<ApiResult<void>> resetPassword({
    required ResetPasswordParams params,
  });
  Future<ApiResult<void>> forgetPassword({required String email});
  Future<ApiResult<void>> logout();
  ApiResult<UserEntity?> getCachedUser();
}

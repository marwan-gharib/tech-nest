import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp({required SignUpParams params});
  Future<Either<Failure, UserEntity>> login({required LoginParams params});
  Future<Either<Failure, UserEntity>> verifyEmail({
    required VerificationEmailParams params,
  });
  Future<Either<Failure, void>> resetPassword({
    required ResetPasswordParams params,
  });
  Future<Either<Failure, void>> forgetPassword({required String email});
}

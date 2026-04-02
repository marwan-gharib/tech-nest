import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUsecase {
  final AuthRepository _repo;

  VerifyEmailUsecase(this._repo);

  Future<Either<Failure, UserEntity>> call({
    required VerificationEmailParams params,
  }) async {
    return await _repo.verifyEmail(params: params);
  }
}

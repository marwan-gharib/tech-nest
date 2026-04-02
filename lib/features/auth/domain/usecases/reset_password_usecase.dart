import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository _repo;

  ResetPasswordUsecase(this._repo);

  Future<Either<Failure, void>> call({
    required ResetPasswordParams params,
  }) async {
    return await _repo.resetPassword(params: params);
  }
}

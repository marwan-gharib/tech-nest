import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository _repo;

  SignUpUsecase(this._repo);

  Future<Either<Failure, UserEntity>> call({
    required SignUpParams params,
  }) async {
    return await _repo.signUp(params: params);
  }
}

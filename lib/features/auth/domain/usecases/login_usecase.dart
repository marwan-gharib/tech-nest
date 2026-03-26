import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';

class LoginUsecase {
  final AuthRepo _repo;

  LoginUsecase(this._repo);

  Future<Either<Failure, UserEntity>> call({
    required LoginParams params,
  }) async {
    return await _repo.login(params: params);
  }
}

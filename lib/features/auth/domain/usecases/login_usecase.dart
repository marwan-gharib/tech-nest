import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repo;

  LoginUsecase(this._repo);

  Future<ApiResult<UserEntity>> call({
    required LoginParams params,
  }) async {
    return await _repo.login(params: params);
  }
}

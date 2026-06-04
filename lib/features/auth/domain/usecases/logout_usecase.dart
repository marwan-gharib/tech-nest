import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repo;

  LogoutUsecase(this._repo);

  Future<ApiResult<void>> call() async {
    return await _repo.logout();
  }
}

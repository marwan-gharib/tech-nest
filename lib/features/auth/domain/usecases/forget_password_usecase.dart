import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class ForgetPasswordUsecase {
  final AuthRepository _repo;

  ForgetPasswordUsecase(this._repo);

  Future<ApiResult<void>> call({required String email}) async {
    return await _repo.forgetPassword(email: email);
  }
}

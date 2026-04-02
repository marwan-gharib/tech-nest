import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class ForgetPasswordUsecase {
  final AuthRepository _repo;

  ForgetPasswordUsecase(this._repo);

  Future<Either<Failure, void>> call({required String email}) async {
    return await _repo.forgetPassword(email: email);
  }
}

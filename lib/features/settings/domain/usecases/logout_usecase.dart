import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/repositories/auth_session_repository.dart';

class LogoutUsecase {
  final AuthSessionRepository _repo;

  LogoutUsecase(this._repo);

  Future<Either<Failure, void>> call() async {
    return await _repo.logout();
  }
}

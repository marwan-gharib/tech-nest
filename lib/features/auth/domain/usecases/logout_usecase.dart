import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';

class LogoutUsecase {
  final AuthRepo _repo;

  LogoutUsecase(this._repo);

  Future<Either<Failure, void>> call() async {
    return await _repo.logout();
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository _repository;

  GetCachedUserUseCase(this._repository);

  Either<Failure, UserEntity?> call() {
    return _repository.getCachedUser();
  }
}

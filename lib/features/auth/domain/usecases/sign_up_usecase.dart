import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';
import 'package:tech_nest/core/errors/mapping/error_mapper.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class SignUpUsecase {
  final AuthRepo _repo;

  SignUpUsecase(this._repo);

  Future<Either<Failure, void>> call({required SignUpParams params}) async {
    try {
      await _repo.signUp(params: params);
      return Right(null);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase {
  final AuthRepo _repo;

  LoginUsecase(this._repo);

  Future<Either<Failure, User>> call({required LoginParams params}) async {
    try {
      return Right(await _repo.login(params: params));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

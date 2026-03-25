import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failures.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';

class VerifyEmailUsecase {
  final AuthRepo _repo;

  VerifyEmailUsecase(this._repo);

  Future<Either<Failure, User>> call({
    required VerificationEmailParams params,
  }) async {
    try {
      return Right(await _repo.verifyEmail(params: params));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

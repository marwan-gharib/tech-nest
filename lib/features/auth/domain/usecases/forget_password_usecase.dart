import 'package:dartz/dartz.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';

class ForgetPasswordUsecase {
  final AuthRepo _repo;

  ForgetPasswordUsecase(this._repo);

  Future<Either<Failure, void>> call({required String email}) async {
    try {
      await _repo.forgetPassword(email: email);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:tech_nest/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:tech_nest/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDataSource;
  final AuthLocalDatasource _localDataSource;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._userLocalDataSource,
  );

  @override
  Future<Either<Failure, UserEntity>> login({
    required LoginParams params,
  }) async {
    try {
      final model = await _remoteDataSource.login(params: params);
      await _localDataSource.saveToken(model.token);
      await _userLocalDataSource.saveUser(model.userModel);
      return Right(model.userModel.toEntity());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearCache();
      await _userLocalDataSource.clearUser();
      return const Right(null);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required SignUpParams params,
  }) async {
    try {
      final model = await _remoteDataSource.signUp(params: params);
      await _userLocalDataSource.saveUser(model);
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyEmail({
    required VerificationEmailParams params,
  }) async {
    try {
      final model = await _remoteDataSource.verifyEmail(params: params);
      await _localDataSource.saveToken(model.token);
      await _userLocalDataSource.saveUser(model.userModel);
      return Right(model.userModel.toEntity());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required ResetPasswordParams params,
  }) async {
    try {
      await _remoteDataSource.resetPassword(params: params);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword({required String email}) async {
    try {
      await _remoteDataSource.forgetPassword(email: email);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/utils/api_result.dart';
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
  Future<ApiResult<UserEntity>> login({
    required LoginParams params,
  }) async {
    try {
      final model = await _remoteDataSource.login(params: params);
      await _localDataSource.saveToken(model.token);
      await _userLocalDataSource.saveUser(model.userModel);
      return ApiSuccess(model.userModel.toEntity());
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearCache();
      await _userLocalDataSource.clearUser();
      return const ApiSuccess(null);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<UserEntity>> signUp({
    required SignUpParams params,
  }) async {
    try {
      final model = await _remoteDataSource.signUp(params: params);
      await _userLocalDataSource.saveUser(model);
      return ApiSuccess(model.toEntity());
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<UserEntity>> verifyEmail({
    required VerificationEmailParams params,
  }) async {
    try {
      final model = await _remoteDataSource.verifyEmail(params: params);
      await _localDataSource.saveToken(model.token);
      await _userLocalDataSource.saveUser(model.userModel);
      return ApiSuccess(model.userModel.toEntity());
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> resetPassword({
    required ResetPasswordParams params,
  }) async {
    try {
      await _remoteDataSource.resetPassword(params: params);
      return const ApiSuccess(null);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> forgetPassword({required String email}) async {
    try {
      await _remoteDataSource.forgetPassword(email: email);
      return const ApiSuccess(null);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  ApiResult<UserEntity?> getCachedUser() {
    try {
      final result = _userLocalDataSource.getUser();
      return switch (result) {
        ApiSuccess(data: final model) => ApiSuccess(model?.toEntity()),
        ApiFailure(failure: final f) => ApiFailure<UserEntity?>(f),
      };
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }
}

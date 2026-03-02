import 'dart:developer';

import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';
import 'package:tech_nest/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:tech_nest/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<User> login({required LoginParams params}) async {
    final model = await _remoteDataSource.login(params: params);

    await _localDataSource.saveToken(model.token);

    log("${sl<CacheService>().get(ApiKeys.token)}");

    return model.userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.clearCache();
  }

  @override
  Future<User> signUp({required SignUpParams params}) async {
    final model = await _remoteDataSource.signUp(params: params);

    return model.toEntity();
  }

  @override
  Future<User> verifyEmail({required VerificationEmailParams params}) async {
    final model = await _remoteDataSource.verifyEmail(params: params);

    await _localDataSource.saveToken(model.token);

    return model.userModel.toEntity();
  }

  @override
  Future<void> resetPassword({required ResetPasswordParams params}) async {
    await _remoteDataSource.resetPassword(params: params);
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await _remoteDataSource.forgetPassword(email: email);
  }
}

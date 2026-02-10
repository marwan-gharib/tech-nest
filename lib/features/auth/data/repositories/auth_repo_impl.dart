import 'package:tech_nest/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource _dataSource;

  AuthRepoImpl(this._dataSource);

  @override
  Future<UserEntity> login({required LoginParams params}) async {
    final model = await _dataSource.login(params: params);

    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
  }

  @override
  Future<void> signUp({required SignUpParams params}) async {
    await _dataSource.signUp(params: params);
  }

  @override
  Future<UserEntity> verifyEmail({
    required VerificationEmailParams params,
  }) async {
    final model = await _dataSource.verifyEmail(params: params);

    return model.toEntity();
  }

  @override
  Future<void> resetPassword({required ResetPasswordParams params}) async {
    await _dataSource.resetPassword(params: params);
  }
}

import 'dart:developer';

import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/remote/api_consumer.dart';
import 'package:tech_nest/features/auth/data/models/auth_model.dart';
import 'package:tech_nest/features/auth/data/models/user_model.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

class AuthRemoteDataSource {
  final ApiConsumer _api;

  AuthRemoteDataSource(this._api);

  Future<UserModel> signUp({required SignUpParams params}) async {
    try {
      final response = await _api.post(
        Endpoints.signUp,
        data: {
          ApiKeys.name: params.name,
          ApiKeys.email: params.email,
          ApiKeys.pass: params.password,
        },
      );

      return UserModel.fromJson(
        response[ApiKeys.data][ApiKeys.user] as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw UnKnownException();
    }
  }

  Future<AuthModel> login({required LoginParams params}) async {
    try {
      final response = await _api.post(
        Endpoints.login,
        data: {ApiKeys.email: params.email, ApiKeys.pass: params.password},
      );

      return AuthModel.fromJson(response[ApiKeys.data] as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw UnKnownException();
    }
  }

  Future<AuthModel> verifyEmail({
    required VerificationEmailParams params,
  }) async {
    try {
      final response = await _api.post(
        Endpoints.verifyEmail,
        data: {ApiKeys.email: params.email, ApiKeys.code: params.code},
      );

      return AuthModel.fromJson(response[ApiKeys.data] as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw UnKnownException();
    }
  }

  Future<void> resetPassword({required ResetPasswordParams params}) async {
    try {
      await _api.post(
        Endpoints.resetPassword,
        data: {
          ApiKeys.email: params.email,
          ApiKeys.code: params.code,
          ApiKeys.newPass: params.newPass,
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw UnKnownException();
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      await _api.post(Endpoints.forgetPassword, data: {ApiKeys.email: email});
    } on AppException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw UnKnownException();
    }
  }

  Future<void> logout() async {
    try {
      await _api.post(Endpoints.logout);
    } on AppException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw UnKnownException();
    }
  }
}

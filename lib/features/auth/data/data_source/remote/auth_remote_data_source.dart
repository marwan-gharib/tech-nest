import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/app_consts.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/core/utils/functions/upload_img_to_api.dart';
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
        isFormData: true,
        data: params.toJson().putIfAbsent(
          ApiKeys.profileImg,
          () async => await uploadImageToAPI(params.img),
        ),
        options: Options(extra: {AppConsts.skipAuth: true}),
      );

      if (response != null) {
        final json = response[ApiKeys.data][ApiKeys.user];
        if (json != null) {
          return UserModel.fromJson(json as Map<String, dynamic>);
        }
      }

      throw UnKnownException();
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
        data: params.toJson(),
        options: Options(extra: {AppConsts.skipAuth: true}),
      );

      if (response != null) {
        final json = response[ApiKeys.data];
        if (json != null) {
          return AuthModel.fromJson(json as Map<String, dynamic>);
        }
      }

      throw UnKnownException();
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
        data: params.toJson(),
        options: Options(extra: {AppConsts.skipAuth: true}),
      );

      final json = response[ApiKeys.data];

      if (response != null && json != null) {
        return AuthModel.fromJson(json as Map<String, dynamic>);
      }

      throw UnKnownException();
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
        data: params.toJson(),
        options: Options(extra: {AppConsts.skipAuth: true}),
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
      await _api.post(
        Endpoints.forgetPassword,
        data: {ApiKeys.email: email},
        options: Options(extra: {AppConsts.skipAuth: true}),
      );
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

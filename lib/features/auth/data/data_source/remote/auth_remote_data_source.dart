import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/core/services/remote/social_services/google_service.dart';
import 'package:tech_nest/core/utils/functions/upload_img_to_api.dart';
import 'package:tech_nest/features/auth/data/models/auth_model.dart';
import 'package:tech_nest/features/auth/data/models/user_model.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/social_login_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

class AuthRemoteDataSource {
  final ApiConsumer _api;

  AuthRemoteDataSource(this._api);

  Future<UserModel> signUp({required SignUpParams params}) async {
    try {
      final response = await _api.post(
        Endpoints.signUp,
        isFormData: true,
        data: {
          ApiKeys.name: params.name,
          ApiKeys.email: params.email,
          ApiKeys.pass: params.password,
          ApiKeys.profileImg: uploadImageToAPI(params.img),
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
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

  Future<AuthModel> googleLogin({required SocialLoginParams params}) async {
    try {
      final googleService = sl<GoogleService>();
      await googleService.signIn();

      final googleId = googleService.googleId;

      if (googleId == null) {
        await googleLogin(params: params);
      }

      final response = await _api.post(
        Endpoints.socialLogin,
        data: {
          ApiKeys.email: params.email,
          ApiKeys.name: params.name,
          ApiKeys.provider: params.provider,
          ApiKeys.socialId: params.socialId,
        },
      );

      return AuthModel.fromJson(response[ApiKeys.data] as Map<String, dynamic>);
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

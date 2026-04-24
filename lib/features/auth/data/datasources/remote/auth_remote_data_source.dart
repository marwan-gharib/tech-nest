import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/core/network/utils/file_upload_utils.dart';
import 'package:tech_nest/features/auth/data/models/user_model.dart';
import 'package:tech_nest/core/shared/utils/logger.dart';
import 'package:tech_nest/features/auth/data/models/auth_model.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

class AuthRemoteDatasource {
  final ApiClient _api;

  AuthRemoteDatasource(this._api);

  Future<UserModel> signUp({required SignUpParams params}) async {
    try {
      final Map<String, dynamic> data = params.toJson();
      data[ApiKeys.profileImg] = await FileUploadUtils.uploadImageToAPI(
        params.img,
      );

      final response = await _api.post(
        Endpoints.signUp,
        isFormData: true,
        data: data,
        extra: {AppConstants.skipAuth: true},
      );

      _validateResponse(response);

      final json = response[ApiKeys.data][ApiKeys.user];
      if (json != null) {
        return UserModel.fromJson(json as Map<String, dynamic>);
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      AppLogger.log(e.toString());
      throw UnKnownException();
    }
  }

  Future<AuthModel> login({required LoginParams params}) async {
    try {
      final response = await _api.post(
        Endpoints.login,
        data: params.toJson(),
        extra: {AppConstants.skipAuth: true},
      );

      _validateResponse(response);

      final json = response[ApiKeys.data];
      if (json != null) {
        return AuthModel.fromJson(json as Map<String, dynamic>);
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      AppLogger.log(e.toString());
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
        extra: {AppConstants.skipAuth: true},
      );

      _validateResponse(response);

      final json = response[ApiKeys.data];
      if (json != null) {
        return AuthModel.fromJson(json as Map<String, dynamic>);
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      AppLogger.log(e.toString());
      throw UnKnownException();
    }
  }

  Future<void> resetPassword({required ResetPasswordParams params}) async {
    try {
      final response = await _api.post(
        Endpoints.resetPassword,
        data: params.toJson(),
        extra: {AppConstants.skipAuth: true},
      );

      _validateResponse(response);
    } on AppException {
      rethrow;
    } catch (e) {
      AppLogger.log(e.toString());
      throw UnKnownException();
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      final response = await _api.post(
        Endpoints.forgetPassword,
        data: {ApiKeys.email: email},
        extra: {AppConstants.skipAuth: true},
      );

      _validateResponse(response);
    } on AppException {
      rethrow;
    } catch (e) {
      AppLogger.log(e.toString());
      throw UnKnownException();
    }
  }

  Future<void> logout() async {
    try {
      await _api.post(Endpoints.logout);
    } on AppException {
      rethrow;
    } catch (e) {
      AppLogger.log(e.toString());
      throw UnKnownException();
    }
  }

  void _validateResponse(dynamic response) {
    if (response == null) {
      throw UnKnownException();
    }

    final int? status = response[ApiKeys.status];
    final String? message = response[ApiKeys.message];

    if (status != null && !status.toString().startsWith("2")) {
      throw ServerException(
        message ?? "An error occurred, please try again",
        activeToUser: true,
      );
    }
  }
}

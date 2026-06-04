import 'dart:convert';

import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/cache_failure.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/auth/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserModel user);
  ApiResult<UserModel?> getUser();
  Future<void> clearUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final CacheService _cacheService;

  UserLocalDataSourceImpl(this._cacheService);

  @override
  Future<void> saveUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    await _cacheService.setData(key: ApiKeys.user, value: userJson);
  }

  @override
  ApiResult<UserModel?> getUser() {
    try {
      final String? userJson = _cacheService.get(ApiKeys.user) as String?;
      if (userJson != null) {
        return ApiSuccess(
          UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>),
        );
      }
      return const ApiSuccess(null);
    } on AppException {
      rethrow;
    } catch (e) {
      return ApiFailure(CacheFailure());
    }
  }

  @override
  Future<void> clearUser() async {
    await _cacheService.remove(ApiKeys.user);
  }
}

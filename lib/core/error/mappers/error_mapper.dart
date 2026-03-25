import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/unauthorized_failure.dart';
import 'package:tech_nest/core/error/failures/cache_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure mapExceptionToFailure(AppException e) {
    return switch (e) {
      ServerException serverException =>
        serverException.activeToUser
            ? ServerFailure(message: serverException.message)
            : ServerFailure(),
      NetworkException() => NetworkFailure(),
      UnAuthorizedException() => UnAuthorizedFailure(),
      CacheException() => CacheFailure(),
      _ => UnknownFailure(),
    };
  }
}

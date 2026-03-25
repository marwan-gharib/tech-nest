import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failures.dart';

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

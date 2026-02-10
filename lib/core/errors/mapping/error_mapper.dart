import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/failures/failures.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure mapExceptionToFailure(AppException e) {
    return switch (e) {
      ServerException() => ServerFailure(),
      NetworkException() => NetworkFailure(),
      UnAuthorizedException() => UnAuthorizedFailure(),
      CacheException() => CacheFailure(),
      _ => UnknownFailure(),
    };
  }
}

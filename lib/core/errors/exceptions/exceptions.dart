abstract class AppException implements Exception {
  final String message;

  AppException(this.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}

class NetworkException extends AppException {
  NetworkException() : super("No Internet Connection.");
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException() : super("UnAuthorized request.");
}

class CacheException extends AppException {
  CacheException() : super("Cache operation failed.");
}

class UnKnownException extends AppException {
  UnKnownException() : super("UnExpected exception Accurred.");
}

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure() : super("Something went wrong on our side. Please try again later.");
}

class NetworkFailure extends Failure {
  NetworkFailure() : super("Please check your internet connection and try again.");
}

class UnAuthorizedFailure extends Failure {
  UnAuthorizedFailure() : super("Your session has expired. Please log in again.");
}

class CacheFailure extends Failure {
  CacheFailure() : super("Unable to load saved data.");
}

class UnknownFailure extends Failure {
  UnknownFailure() : super("An unexpected error occurred. Please try again.");
}

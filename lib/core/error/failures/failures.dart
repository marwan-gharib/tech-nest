abstract class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({
    super.message = "Something went wrong on our side. Please try again later.",
  });
}

class NetworkFailure extends Failure {
  NetworkFailure()
    : super(message: "Please check your internet connection and try again.");
}

class UnAuthorizedFailure extends Failure {
  UnAuthorizedFailure()
    : super(message: "Your session has expired. Please login again.");
}

class CacheFailure extends Failure {
  CacheFailure() : super(message: "Unable to load saved data.");
}

class UnknownFailure extends Failure {
  UnknownFailure()
    : super(message: "An unexpected error occurred. Please try again.");
}

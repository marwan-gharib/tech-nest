import 'failure.dart';

class ServerFailure extends Failure {
  ServerFailure({
    super.message = "Something went wrong on our side. Please try again later.",
  });
}

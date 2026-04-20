import 'failure.dart';

class UnAuthorizedFailure extends Failure {
  UnAuthorizedFailure([
    String message = "Your session has expired. Please login again.",
  ]) : super(message: message);
}

import 'failure.dart';

class UnAuthorizedFailure extends Failure {
  UnAuthorizedFailure()
    : super(message: "Your session has expired. Please login again.");
}

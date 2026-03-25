import 'failure.dart';

class UnknownFailure extends Failure {
  UnknownFailure()
    : super(message: "An unexpected error occurred. Please try again.");
}

import 'failure.dart';

class NetworkFailure extends Failure {
  NetworkFailure()
    : super(message: "Please check your internet connection and try again.");
}

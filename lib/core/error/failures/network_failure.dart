import 'failure.dart';

class NetworkFailure extends Failure {
  NetworkFailure() : super(message: "No internet connection.");
}

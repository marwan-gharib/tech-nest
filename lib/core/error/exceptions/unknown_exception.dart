import 'app_exception.dart';

class UnKnownException extends AppException {
  UnKnownException() : super("Unexpected exception occurred.");
}

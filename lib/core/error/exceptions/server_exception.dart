import 'app_exception.dart';

class ServerException extends AppException {
  final bool activeToUser;

  ServerException(super.message, {this.activeToUser = false});
}

import 'app_exception.dart';

class UnAuthorizedException extends AppException {
  UnAuthorizedException([super.message = "UnAuthorized request."]);
}

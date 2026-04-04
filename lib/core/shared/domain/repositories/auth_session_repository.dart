import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

abstract class AuthSessionRepository {
  Future<Either<Failure, void>> logout();
}

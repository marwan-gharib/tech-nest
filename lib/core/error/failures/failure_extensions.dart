import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';

extension FailureNetworkX on Failure {
  bool get isNetworkFailure => this is NetworkFailure;
}

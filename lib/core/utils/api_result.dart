import 'package:tech_nest/core/error/failures/failure.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R fold<R>(R Function(Failure failure) ifLeft, R Function(T data) ifRight) {
    return switch (this) {
      ApiFailure(failure: final f) => ifLeft(f),
      ApiSuccess(data: final d) => ifRight(d),
    };
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final Failure failure;
  const ApiFailure(this.failure);
}

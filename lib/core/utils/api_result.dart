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

  @override
  bool operator ==(Object other) {
    return other is ApiSuccess && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

class ApiFailure<T> extends ApiResult<T> {
  final Failure failure;
  const ApiFailure(this.failure);

  @override
  bool operator ==(Object other) {
    return other is ApiFailure && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;
}

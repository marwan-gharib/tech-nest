part of 'forget_password_cubit.dart';

@immutable
sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

final class ForgetPasswordLoading extends ForgetPasswordState {
  const ForgetPasswordLoading();
}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  const ForgetPasswordSuccess();
}

final class ForgetPasswordFailed extends ForgetPasswordState {
  final Failure failure;
  const ForgetPasswordFailed({required this.failure});

  @override
  List<Object> get props => [failure];
}

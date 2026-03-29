part of 'reset_password_cubit.dart';

@immutable
sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

final class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

final class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess();
}

final class ResetPasswordFailed extends ResetPasswordState {
  final Failure failure;

  const ResetPasswordFailed({required this.failure});

  @override
  List<Object> get props => [failure];
}

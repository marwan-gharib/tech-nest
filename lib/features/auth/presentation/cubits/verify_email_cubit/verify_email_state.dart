part of 'verify_email_cubit.dart';

@immutable
sealed class VerifyEmailState extends Equatable {
  const VerifyEmailState();

  @override
  List<Object> get props => [];
}

final class VerifyEmailInitial extends VerifyEmailState {
  const VerifyEmailInitial();
}

final class VerifyEmailLoading extends VerifyEmailState {
  const VerifyEmailLoading();
}

final class VerifyEmailSuccess extends VerifyEmailState {
  final UserEntity user;

  const VerifyEmailSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class VerifyEmailFailed extends VerifyEmailState {
  final String message;
  const VerifyEmailFailed({required this.message});

  @override
  List<Object> get props => [message];
}

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
  const VerifyEmailSuccess();
}

final class VerifyEmailFailed extends VerifyEmailState {
  final String message;
  final bool isNoConnection;

  const VerifyEmailFailed({
    required this.message,
    required this.isNoConnection,
  });

  @override
  List<Object> get props => [message, isNoConnection];
}

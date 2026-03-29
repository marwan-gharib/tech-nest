part of 'login_cubit.dart';

@immutable
sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class LoginFailed extends LoginState {
  final String message;
  final bool isNoConnection;

  const LoginFailed({
    required this.message,
    required this.isNoConnection,
  });

  @override
  List<Object> get props => [message, isNoConnection];
}

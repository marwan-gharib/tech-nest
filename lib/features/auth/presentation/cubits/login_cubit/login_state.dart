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
  final User user;

  const LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class LoginFailed extends LoginState {
  final String message;
  const LoginFailed({required this.message});

  @override
  List<Object> get props => [message];
}

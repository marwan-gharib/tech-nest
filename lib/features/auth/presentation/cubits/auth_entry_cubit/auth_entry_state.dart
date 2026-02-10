part of 'auth_entry_cubit.dart';

@immutable
sealed class AuthEntryState extends Equatable {
  const AuthEntryState();

  @override
  List<Object> get props => [];
}

final class AuthEntryInitial extends AuthEntryState {
  const AuthEntryInitial();
}

final class AuthEntryLoading extends AuthEntryState {
  const AuthEntryLoading();
}

final class AuthEntrySuccess extends AuthEntryState {
  final UserEntity? user;

  const AuthEntrySuccess({this.user});

  @override
  List<Object> get props => user != null ? [user!] : [];
}

final class AuthEntryFailed extends AuthEntryState {
  final String message;
  const AuthEntryFailed({required this.message});

  @override
  List<Object> get props => [message];
}

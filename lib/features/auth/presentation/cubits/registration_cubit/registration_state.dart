part of 'registration_cubit.dart';

@immutable
sealed class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

final class RegistrationInitial extends RegistrationState {
  const RegistrationInitial();
}

final class RegistrationLoading extends RegistrationState {
  const RegistrationLoading();
}

final class RegistrationSuccess extends RegistrationState {
  final UserEntity user;
  const RegistrationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class RegistrationFailed extends RegistrationState {
  final String message;
  final bool isNoConnection;

  const RegistrationFailed({
    required this.message,
    required this.isNoConnection,
  });

  @override
  List<Object> get props => [message, isNoConnection];
}

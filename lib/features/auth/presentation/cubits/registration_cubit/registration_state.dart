part of 'registration_cubit.dart';

@immutable
sealed class registrationState extends Equatable {
  const registrationState();

  @override
  List<Object> get props => [];
}

final class registrationInitial extends registrationState {
  const registrationInitial();
}

final class registrationLoading extends registrationState {
  const registrationLoading();
}

final class registrationSuccess extends registrationState {
  final User user;
  const registrationSuccess({required this.user});
}

final class registrationFailed extends registrationState {
  final String message;
  const registrationFailed({required this.message});

  @override
  List<Object> get props => [message];
}

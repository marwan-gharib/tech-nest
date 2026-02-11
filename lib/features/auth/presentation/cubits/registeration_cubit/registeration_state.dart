part of 'registeration_cubit.dart';

@immutable
sealed class RegisterationState extends Equatable {
  const RegisterationState();

  @override
  List<Object> get props => [];
}

final class RegisterationInitial extends RegisterationState {
  const RegisterationInitial();
}

final class RegisterationLoading extends RegisterationState {
  const RegisterationLoading();
}

final class RegisterationSuccess extends RegisterationState {
  final UserEntity user;
  const RegisterationSuccess({required this.user});
}

final class RegisterationFailed extends RegisterationState {
  final String message;
  const RegisterationFailed({required this.message});

  @override
  List<Object> get props => [message];
}

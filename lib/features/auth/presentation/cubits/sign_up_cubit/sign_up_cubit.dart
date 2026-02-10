import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUsecase _signUpUsecase;
  SignUpCubit(SignUpUsecase signUpUsecase)
    : _signUpUsecase = signUpUsecase,
      super(SignUpInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());

    final res = await _signUpUsecase.call(
      params: SignUpParams(name: name, email: email, password: password),
    );

    res.fold(
      (failure) => SignUpFailed(message: failure.message),
      (_) => SignUpSuccess(),
    );
  }
}

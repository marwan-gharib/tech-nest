import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/core/error/failures/failure_extensions.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase _loginUsecase;

  LoginCubit(LoginUsecase loginUsecase)
    : _loginUsecase = loginUsecase,
      super(const LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());

    final res = await _loginUsecase.call(
      params: LoginParams(email: email, password: password),
    );

    res.fold(
      (failure) => emit(
        LoginFailed(
          message: failure.message,
          isNoConnection: failure.isNetworkFailure,
        ),
      ),
      (user) => emit(LoginSuccess(user: user)),
    );
  }
}

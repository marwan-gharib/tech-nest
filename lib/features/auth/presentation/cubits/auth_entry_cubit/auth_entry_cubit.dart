import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/reset_password_usecase.dart';

part 'auth_entry_state.dart';

class AuthEntryCubit extends Cubit<AuthEntryState> {
  final LoginUsecase _loginUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;

  AuthEntryCubit(
    LoginUsecase loginUsecase,
    ResetPasswordUsecase resetPasswordUsecase,
  ) : _resetPasswordUsecase = resetPasswordUsecase,
      _loginUsecase = loginUsecase,
      super(const AuthEntryInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthEntryLoading());

    final res = await _loginUsecase.call(
      params: LoginParams(email: email, password: password),
    );

    res.fold(
      (failure) => emit(AuthEntryFailed(message: failure.message)),
      (user) => emit(AuthEntrySuccess(user: user)),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPass,
  }) async {
    emit(const AuthEntryLoading());

    final res = await _resetPasswordUsecase.call(
      params: ResetPasswordParams(email: email, code: code, newPass: newPass),
    );

    res.fold(
      (failure) => emit(AuthEntryFailed(message: failure.message)),
      (_) => emit(const AuthEntrySuccess()),
    );
  }
}

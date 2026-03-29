import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUsecase _resetPasswordUsecase;

  ResetPasswordCubit(this._resetPasswordUsecase)
    : super(const ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPass,
  }) async {
    emit(const ResetPasswordLoading());

    final res = await _resetPasswordUsecase.call(
      params: ResetPasswordParams(email: email, code: code, newPass: newPass),
    );

    res.fold(
      (failure) => emit(ResetPasswordFailed(failure: failure)),
      (_) => emit(const ResetPasswordSuccess()),
    );
  }
}

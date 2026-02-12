import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/auth/domain/usecases/forget_password_usecase.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUsecase _forgetPasswordUsecase;

  ForgetPasswordCubit(this._forgetPasswordUsecase)
    : super(const ForgetPasswordInitial());

  Future<void> forgetPassword({required String email}) async {
    emit(const ForgetPasswordLoading());

    final res = await _forgetPasswordUsecase.call(email: email);

    res.fold(
      (failure) => emit(ForgetPasswordFailed(message: failure.message)),
      (_) => emit(const ForgetPasswordSuccess()),
    );
  }
}

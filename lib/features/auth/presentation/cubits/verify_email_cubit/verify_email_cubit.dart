import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/verify_email_usecase.dart';

part 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final VerifyEmailUsecase _verifyEmailUsecase;
  VerifyEmailCubit(VerifyEmailUsecase verifyEmailUsecase)
    : _verifyEmailUsecase = verifyEmailUsecase,
      super(const VerifyEmailInitial());

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    emit(const VerifyEmailLoading());

    final res = await _verifyEmailUsecase.call(
      params: VerificationEmailParams(email: email, code: code),
    );

    res.fold(
      (failure) => emit(VerifyEmailFailed(failure: failure)),
      (_) => emit(const VerifyEmailSuccess()),
    );
  }
}

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';

part 'registeration_state.dart';

class RegisterationCubit extends Cubit<RegisterationState> {
  final SignUpUsecase _signUpUsecase;

  XFile? profileImg;

  RegisterationCubit(SignUpUsecase signUpUsecase)
    : _signUpUsecase = signUpUsecase,
      super(const RegisterationInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const RegisterationLoading());

    final res = await _signUpUsecase.call(
      params: SignUpParams(
        name: name,
        email: email,
        password: password,
        img: File(profileImg!.path),
      ),
    );

    res.fold(
      (failure) => emit(RegisterationFailed(message: failure.message)),
      (user) => emit(RegisterationSuccess(user: user)),
    );
  }
}

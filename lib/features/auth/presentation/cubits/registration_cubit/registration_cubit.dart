import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';

part 'registration_state.dart';

class registrationCubit extends Cubit<registrationState> {
  final SignUpUsecase _signUpUsecase;

  XFile? profileImg;

  registrationCubit(SignUpUsecase signUpUsecase)
    : _signUpUsecase = signUpUsecase,
      super(const registrationInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const registrationLoading());

    final res = await _signUpUsecase.call(
      params: SignUpParams(
        name: name,
        email: email,
        password: password,
        img: File(profileImg!.path),
      ),
    );

    res.fold(
      (failure) => emit(registrationFailed(message: failure.message)),
      (user) => emit(registrationSuccess(user: user)),
    );
  }
}

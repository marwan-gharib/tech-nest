import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/auth/domain/usecases/get_cached_user_usecase.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetCachedUserUseCase _getCachedUserUseCase;

  UserProfileCubit(this._getCachedUserUseCase)
    : super(const UserProfileInitial()) {
    loadUser();
  }

  void loadUser() {
    emit(const UserProfileLoading());

    final result = _getCachedUserUseCase();

    result.fold(
      (failure) => emit(const UserProfileError('Failed to load user profile')),
      (user) {
        if (user != null) {
          emit(UserProfileLoaded(user));
        } else {
          emit(const UserProfileEmpty());
        }
      },
    );
  }
}

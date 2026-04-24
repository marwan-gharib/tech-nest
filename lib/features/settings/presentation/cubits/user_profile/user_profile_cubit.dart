import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/auth/data/datasources/local/user_local_datasource.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserLocalDataSource _userLocalDataSource;

  UserProfileCubit(this._userLocalDataSource)
    : super(const UserProfileInitial()) {
    loadUser();
  }

  void loadUser() {
    emit(const UserProfileLoading());

    final result = _userLocalDataSource.getUser();

    result.fold(
      (failure) => emit(const UserProfileError('Failed to load user profile')),
      (user) {
        if (user != null) {
          emit(UserProfileLoaded(user.toEntity()));
        } else {
          emit(const UserProfileEmpty());
        }
      },
    );
  }
}

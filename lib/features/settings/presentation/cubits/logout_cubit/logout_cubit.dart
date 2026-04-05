import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/usecases/logout_usecase.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._logoutUsecase) : super(const LogoutInitial());

  final LogoutUsecase _logoutUsecase;

  Future<void> logout() async {
    emit(const LogoutLoading());
    final result = await _logoutUsecase.call();
    result.fold(
      (failure) => emit(LogoutFailure(failure)),
      (_) => emit(const LogoutSuccess()),
    );
  }
}

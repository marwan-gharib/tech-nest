import 'package:get_it/get_it.dart';
import 'package:tech_nest/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';

void initSettingsDI(GetIt sl) {
  sl.registerFactory<UserProfileCubit>(
    () => UserProfileCubit(sl<GetCachedUserUseCase>()),
  );
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl<LogoutUsecase>()));
}

import 'package:get_it/get_it.dart';
import 'package:tech_nest/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:tech_nest/features/settings/domain/usecases/logout_usecase.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';

void initSettingsDI(GetIt sl) {
  sl.registerFactory<UserProfileCubit>(
    () => UserProfileCubit(sl<UserLocalDataSource>()),
  );
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl<LogoutUsecase>()));
}

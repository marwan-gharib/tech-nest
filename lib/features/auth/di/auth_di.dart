import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/services/remote/api_consumer.dart';
import 'package:tech_nest/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';
import 'package:tech_nest/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:tech_nest/features/auth/presentation/cubits/auth_entry_cubit/auth_entry_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';

void initAuthDI(GetIt sl) {
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl<ApiConsumer>()));

  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => LoginUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => SignUpUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => VerifyEmailUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepo>()));

  sl.registerFactory(
    () => AuthEntryCubit(sl<LoginUsecase>(), sl<ResetPasswordUsecase>()),
  );
  sl.registerFactory(() => SignUpCubit(sl<SignUpUsecase>()));
  sl.registerFactory(() => VerifyEmailCubit(sl<VerifyEmailUsecase>()));
}

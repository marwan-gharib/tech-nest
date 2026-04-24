import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:tech_nest/features/settings/domain/usecases/logout_usecase.dart';
import 'package:tech_nest/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:tech_nest/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';

void initAuthDI(GetIt sl) {
  sl.registerLazySingleton(() => AuthRemoteDatasource(sl<ApiClient>()));
  sl.registerLazySingleton(
    () => AuthLocalDatasource(sl<SecureStorageClient>()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl<CacheService>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDatasource>(),
      sl<AuthLocalDatasource>(),
      sl<UserLocalDataSource>(),
    ),
  );

  /***************usecases*************/
  sl.registerLazySingleton(() => LoginUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyEmailUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgetPasswordUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepository>()));

  /***************cubits*************/
  sl.registerFactory(() => LoginCubit(sl<LoginUsecase>()));
  sl.registerFactory(() => ForgetPasswordCubit(sl<ForgetPasswordUsecase>()));
  sl.registerFactory(() => ResetPasswordCubit(sl<ResetPasswordUsecase>()));
  sl.registerFactory(() => RegistrationCubit(sl<SignUpUsecase>()));
  sl.registerFactory(() => VerifyEmailCubit(sl<VerifyEmailUsecase>()));
}

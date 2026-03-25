import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/services/local/secure/secure_storage_service.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:tech_nest/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repo.dart';
import 'package:tech_nest/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tech_nest/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';

void initAuthDI(GetIt sl) {
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => AuthLocalDataSource(sl<SecureStorageService>()));

  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(sl<AuthRemoteDataSource>(), sl<AuthLocalDataSource>()),
  );

  /***************usecases*************/
  sl.registerLazySingleton(() => LoginUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => SignUpUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => VerifyEmailUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => ForgetPasswordUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepo>()));

  /***************cubits*************/
  sl.registerFactory(() => LoginCubit(sl<LoginUsecase>()));
  sl.registerFactory(() => ForgetPasswordCubit(sl<ForgetPasswordUsecase>()));
  sl.registerFactory(() => ResetPasswordCubit(sl<ResetPasswordUsecase>()));
  sl.registerFactory(() => RegistrationCubit(sl<SignUpUsecase>()));
  sl.registerFactory(() => VerifyEmailCubit(sl<VerifyEmailUsecase>()));
}

import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:tech_nest/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:tech_nest/features/notifications/domain/repositories/notification_repository.dart';
import 'package:tech_nest/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:tech_nest/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:tech_nest/features/notifications/domain/usecases/save_fcm_token_usecase.dart';
import 'package:tech_nest/features/notifications/presentation/notification_cubit/notification_cubit.dart';

void initNotificationsDI(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSource(sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<NotificationRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetNotificationsUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton(
    () => MarkNotificationReadUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton(
    () => SaveFCMTokenUseCase(sl<NotificationRepository>()),
  );

  // Cubit
  sl.registerFactory(
    () => NotificationCubit(
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
      markNotificationReadUseCase: sl<MarkNotificationReadUseCase>(),
    ),
  );
}

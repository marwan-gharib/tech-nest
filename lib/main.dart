import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/app/app_settings.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/app/tech_nest_app.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/services/notification_service.dart';
import 'package:tech_nest/core/services/notification_handler_facade.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/firebase_options.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  await initDependencies();

  final AppSettings appSettings = sl<AppSettings>();
  await appSettings.initLocale();
  await appSettings.initAuth();

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ThemeCubit>()),
          BlocProvider(create: (_) => sl<LocaleCubit>()),
        ],
        child: TechNestApp(initialMessage: initialMessage),
      ),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_initializeNotifications());
  });
}

Future<void> _initializeNotifications() async {
  try {
    await sl<NotificationHandlerFacade>().initialize();
    await sl<NotificationService>().initialize();
  } catch (error) {
    AppLogger.error('Notification initialization failed: $error');
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/app/app_settings.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/app/tech_nest_app.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/services/notification_service.dart';
import 'package:tech_nest/firebase_options.dart';
import 'package:tech_nest/i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies();

  final AppSettings appSettings = sl<AppSettings>();
  await appSettings.initLocale();
  await appSettings.initAuth();

  await sl<NotificationService>().initialize();

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ThemeCubit>()),
          BlocProvider(create: (_) => sl<LocaleCubit>()),
        ],
        child: const TechNestApp(),
      ),
    ),
  );
}

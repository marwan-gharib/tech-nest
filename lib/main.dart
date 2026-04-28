import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/app/app_settings.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/app/tech_nest_app.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final AppSettings appSettings = sl<AppSettings>();

  await appSettings.initLocale();
  await appSettings.initAuth();

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<ThemeCubit>()),
          BlocProvider(create: (context) => sl<LocaleCubit>()),
        ],
        child: const TechNestApp(),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:tech_nest/service_locator.dart';
import 'package:tech_nest/tech_nest_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final secureStorage = sl<SecureStorageClient>();
  final authNotifier = sl<AuthNotifier>();

  if (await secureStorage.hasToken()) {
    authNotifier.login();
  } else {
    authNotifier.logout();
  }

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

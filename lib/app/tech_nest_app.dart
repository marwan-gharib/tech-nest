import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tech_nest/app/app_router.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/services/notification_handler_facade.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class TechNestApp extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const TechNestApp({super.key, this.initialMessage});

  @override
  State<TechNestApp> createState() => _TechNestAppState();
}

class _TechNestAppState extends State<TechNestApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialMessage != null) {
        // Handle the initial message safely after the app mounts
        sl<NotificationHandlerFacade>().handleInitialMessage(widget.initialMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeInOut,
      themeMode: context.select<ThemeCubit, ThemeMode>(
        (cubit) => cubit.state.mode,
      ),
      routerConfig: AppRouter.router,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}

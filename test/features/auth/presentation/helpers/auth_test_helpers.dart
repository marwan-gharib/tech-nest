import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/profile_image_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class MockRegistrationCubit extends MockCubit<RegistrationState>
    implements RegistrationCubit {}

class MockProfileImageCubit extends MockCubit<XFile?>
    implements ProfileImageCubit {}

class MockForgetPasswordCubit extends MockCubit<ForgetPasswordState>
    implements ForgetPasswordCubit {}

Widget buildTestableWidget({
  required Widget child,
  required List<BlocProvider> providers,
  GoRouter? router,
}) {
  LocaleSettings.setLocaleSync(AppLocale.en);

  final goRouter =
      router ??
      GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, _) => child),
          GoRoute(path: '/home', builder: (_, _) => const Scaffold()),
          GoRoute(path: '/login', builder: (_, _) => const Scaffold()),
          GoRoute(path: '/sign-up', builder: (_, _) => const Scaffold()),
        ],
      );

  return TranslationProvider(
    child: MultiBlocProvider(
      providers: providers,
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: goRouter,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
    ),
  );
}

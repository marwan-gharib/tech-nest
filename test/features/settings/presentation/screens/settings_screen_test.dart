import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_state.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_state.dart';
import 'package:tech_nest/features/settings/presentation/screens/settings_screen.dart';
import 'package:tech_nest/features/settings/presentation/widgets/language_selector_tile.dart';
import 'package:tech_nest/features/settings/presentation/widgets/theme_selector.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockLocaleCubit extends MockCubit<LocaleState> implements LocaleCubit {}

class MockUserProfileCubit extends MockCubit<UserProfileState>
    implements UserProfileCubit {}

class MockLogoutCubit extends MockCubit<LogoutState> implements LogoutCubit {}

class MockAuthNotifier extends Mock implements AuthNotifier {}

void main() {
  late MockThemeCubit mockThemeCubit;
  late MockLocaleCubit mockLocaleCubit;
  late MockUserProfileCubit mockUserProfileCubit;
  late MockLogoutCubit mockLogoutCubit;
  late MockAuthNotifier mockAuthNotifier;

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockLocaleCubit = MockLocaleCubit();
    mockUserProfileCubit = MockUserProfileCubit();
    mockLogoutCubit = MockLogoutCubit();
    mockAuthNotifier = MockAuthNotifier();

    when(
      () => mockThemeCubit.state,
    ).thenReturn(const ThemeState(mode: ThemeMode.system));
    when(
      () => mockLocaleCubit.state,
    ).thenReturn(const LocaleState(AppLocale.en));
    when(
      () => mockUserProfileCubit.state,
    ).thenReturn(const UserProfileInitial());
    when(() => mockUserProfileCubit.loadUser()).thenReturn(null);
    when(() => mockLogoutCubit.state).thenReturn(const LogoutInitial());
    when(() => mockLogoutCubit.logout()).thenAnswer((_) async {});
    when(() => mockAuthNotifier.logout()).thenReturn(null);

    if (sl.isRegistered<UserProfileCubit>()) {
      sl.unregister<UserProfileCubit>();
    }
    if (sl.isRegistered<LogoutCubit>()) {
      sl.unregister<LogoutCubit>();
    }
    if (sl.isRegistered<AuthNotifier>()) {
      sl.unregister<AuthNotifier>();
    }

    sl.registerFactory<UserProfileCubit>(() => mockUserProfileCubit);
    sl.registerFactory<LogoutCubit>(() => mockLogoutCubit);
    sl.registerLazySingleton<AuthNotifier>(() => mockAuthNotifier);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  testWidgets('renders settings screen sections and nested controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
            BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
          ],
          child: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.settings.title), findsOneWidget);
    expect(find.byType(ThemeSelector), findsOneWidget);
    expect(find.byType(LanguageSelectorTile), findsOneWidget);
    verify(() => mockUserProfileCubit.loadUser()).called(1);
  });
}

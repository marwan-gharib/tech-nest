import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_state.dart';
import 'package:tech_nest/features/settings/presentation/widgets/theme_selector.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

void main() {
  late MockThemeCubit mockThemeCubit;

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    when(
      () => mockThemeCubit.state,
    ).thenReturn(const ThemeState(mode: ThemeMode.system));
    when(() => mockThemeCubit.updateThemeMode(any())).thenAnswer((_) {});
  });

  testWidgets('renders all theme options', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<ThemeCubit>.value(
          value: mockThemeCubit,
          child: const Scaffold(body: ThemeSelector()),
        ),
      ),
    );

    expect(find.text(t.settings.systemMode), findsOneWidget);
    expect(find.text(t.settings.lightMode), findsOneWidget);
    expect(find.text(t.settings.darkMode), findsOneWidget);
  });

  testWidgets('calls updateThemeMode when selecting light mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<ThemeCubit>.value(
          value: mockThemeCubit,
          child: const Scaffold(body: ThemeSelector()),
        ),
      ),
    );

    await tester.tap(find.text(t.settings.lightMode));
    await tester.pump();

    verify(() => mockThemeCubit.updateThemeMode(ThemeMode.light)).called(1);
  });

  testWidgets('rebuilds selected option when state changes', (tester) async {
    whenListen(
      mockThemeCubit,
      Stream.fromIterable([
        const ThemeState(mode: ThemeMode.dark),
        const ThemeState(mode: ThemeMode.light),
      ]),
      initialState: const ThemeState(mode: ThemeMode.system),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<ThemeCubit>.value(
          value: mockThemeCubit,
          child: const Scaffold(body: ThemeSelector()),
        ),
      ),
    );

    await tester.pump();
    verifyNever(() => mockThemeCubit.updateThemeMode(any()));

    await tester.pump();
    expect(find.text(t.settings.lightMode), findsOneWidget);
    expect(find.text(t.settings.darkMode), findsOneWidget);
  });
}

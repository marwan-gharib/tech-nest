import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/features/settings/presentation/widgets/language_selector_tile.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockLocaleCubit extends MockCubit<LocaleState> implements LocaleCubit {}

void main() {
  late MockLocaleCubit mockLocaleCubit;

  setUpAll(() {
    registerFallbackValue(AppLocale.en);
  });

  setUp(() {
    mockLocaleCubit = MockLocaleCubit();
    when(
      () => mockLocaleCubit.state,
    ).thenReturn(const LocaleState(AppLocale.en));
    when(() => mockLocaleCubit.setLocale(any())).thenAnswer((_) async {});
  });

  testWidgets('renders language segmented control', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<LocaleCubit>.value(
          value: mockLocaleCubit,
          child: const Scaffold(body: LanguageSelectorTile()),
        ),
      ),
    );

    expect(find.byType(SegmentedButton<AppLocale>), findsOneWidget);
    expect(find.text(t.settings.english), findsOneWidget);
    expect(find.text(t.settings.arabic), findsOneWidget);
  });

  testWidgets('invokes setLocale when Arabic segment is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<LocaleCubit>.value(
          value: mockLocaleCubit,
          child: const Scaffold(body: LanguageSelectorTile()),
        ),
      ),
    );

    await tester.tap(find.text(t.settings.arabic));
    await tester.pump();

    verify(() => mockLocaleCubit.setLocale(AppLocale.ar)).called(1);
  });

  testWidgets('rebuilds when locale state changes', (tester) async {
    whenListen(
      mockLocaleCubit,
      Stream.fromIterable([
        const LocaleState(AppLocale.ar),
        const LocaleState(AppLocale.en),
      ]),
      initialState: const LocaleState(AppLocale.en),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<LocaleCubit>.value(
          value: mockLocaleCubit,
          child: const Scaffold(body: LanguageSelectorTile()),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(SegmentedButton<AppLocale>), findsOneWidget);

    await tester.pump();
    expect(find.byType(SegmentedButton<AppLocale>), findsOneWidget);
  });
}

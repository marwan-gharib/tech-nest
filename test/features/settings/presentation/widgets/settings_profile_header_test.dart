import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_state.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_profile_header.dart';

import '../../../../helpers/test_app.dart';

class MockUserProfileCubit extends MockCubit<UserProfileState>
    implements UserProfileCubit {}

void main() {
  late MockUserProfileCubit mockUserProfileCubit;

  final user = UserEntity(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    image: null,
  );

  setUp(() {
    mockUserProfileCubit = MockUserProfileCubit();
    when(
      () => mockUserProfileCubit.state,
    ).thenReturn(const UserProfileInitial());
  });

  testWidgets('shows guest UI in initial state', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<UserProfileCubit>.value(
          value: mockUserProfileCubit,
          child: const Scaffold(body: SettingsProfileHeader()),
        ),
      ),
    );

    expect(find.text('Guest User'), findsOneWidget);
    expect(find.text('Please sign in to access full features'), findsOneWidget);
  });

  testWidgets('shows loading subtitle in loading state', (tester) async {
    when(
      () => mockUserProfileCubit.state,
    ).thenReturn(const UserProfileLoading());

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<UserProfileCubit>.value(
          value: mockUserProfileCubit,
          child: const Scaffold(body: SettingsProfileHeader()),
        ),
      ),
    );

    expect(find.text('Loading profile...'), findsOneWidget);
    expect(find.text('Guest User'), findsOneWidget);
  });

  testWidgets('shows loaded name and email in loaded state', (tester) async {
    when(() => mockUserProfileCubit.state).thenReturn(UserProfileLoaded(user));

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<UserProfileCubit>.value(
          value: mockUserProfileCubit,
          child: const Scaffold(body: SettingsProfileHeader()),
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
  });

  testWidgets('rebuilds correctly across consecutive profile states', (
    tester,
  ) async {
    whenListen(
      mockUserProfileCubit,
      Stream<UserProfileState>.periodic(
        const Duration(milliseconds: 10),
        (index) => [
          const UserProfileLoading(),
          UserProfileLoaded(user),
          const UserProfileError('x'),
          const UserProfileEmpty(),
        ][index],
      ).take(4),
      initialState: const UserProfileInitial(),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<UserProfileCubit>.value(
          value: mockUserProfileCubit,
          child: const Scaffold(body: SettingsProfileHeader()),
        ),
      ),
    );

    expect(find.text('Please sign in to access full features'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('Loading profile...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('Error loading profile'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('Please sign in to access full features'), findsOneWidget);
  });
}

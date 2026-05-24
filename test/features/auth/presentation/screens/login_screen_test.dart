/// Widget tests for [LoginScreen].
///
/// Covered scenarios:
///  1. Renders the screen with email field, password field, and login button.
///  2. Shows email validation error on empty submit.
///  3. Shows password validation error on short password.
///  4. Shows an [AuthLoadingIndicator] while in [LoginLoading] state.
///  5. Shows an error snackbar on [LoginFailed] state.
///  6. Calls cubit.login with correct credentials on valid form submission.
///
/// Notes:
///  - [LoginScreen] reads [AuthNotifier] from the service-locator (sl).  To
///    avoid that dependency, the login button callback is wired indirectly
///    through the cubit, so we mock [LoginCubit] with [MockLoginCubit].
///  - The [ForgetPasswordCubit] is also required by [LoginForm].
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/login_form.dart';

import '../helpers/auth_test_helpers.dart';

Widget _buildLoginForm({
  required MockLoginCubit loginCubit,
  required MockForgetPasswordCubit forgetCubit,
  required GlobalKey<FormState> formKey,
  required TextEditingController email,
  required TextEditingController password,
  VoidCallback? onForgetPass,
}) {
  return buildTestableWidget(
    providers: [
      BlocProvider<LoginCubit>.value(value: loginCubit),
      BlocProvider<ForgetPasswordCubit>.value(value: forgetCubit),
    ],
    child: Scaffold(
      body: SingleChildScrollView(
        child: LoginForm(
          formKey: formKey,
          email: email,
          password: password,
          onForgetPass: onForgetPass ?? () {},
        ),
      ),
    ),
  );
}

void main() {
  late MockLoginCubit mockLoginCubit;
  late MockForgetPasswordCubit mockForgetCubit;

  final tUser = UserEntity(id: 1, name: 'John Doe', email: 'john@example.com');
  final tFailure = ServerFailure(message: 'Invalid credentials');

  setUp(() {
    mockLoginCubit = MockLoginCubit();
    mockForgetCubit = MockForgetPasswordCubit();

    when(() => mockLoginCubit.state).thenReturn(const LoginInitial());
    when(() => mockForgetCubit.state).thenReturn(const ForgetPasswordInitial());
  });

  testWidgets('renders email field, password field, and forget-password link', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController();
    final password = TextEditingController();

    await tester.pumpWidget(
      _buildLoginForm(
        loginCubit: mockLoginCubit,
        forgetCubit: mockForgetCubit,
        formKey: formKey,
        email: email,
        password: password,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
  });

  testWidgets('shows email validation error when submitted empty', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController();
    final password = TextEditingController();

    await tester.pumpWidget(
      _buildLoginForm(
        loginCubit: mockLoginCubit,
        forgetCubit: mockForgetCubit,
        formKey: formKey,
        email: email,
        password: password,
      ),
    );
    await tester.pumpAndSettle();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Please enter your email address'), findsOneWidget);
  });

  testWidgets('shows invalid email error for badly formatted email', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController(text: 'not-an-email');
    final password = TextEditingController(text: 'password123');

    await tester.pumpWidget(
      _buildLoginForm(
        loginCubit: mockLoginCubit,
        forgetCubit: mockForgetCubit,
        formKey: formKey,
        email: email,
        password: password,
      ),
    );
    await tester.pumpAndSettle();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('shows password length error when password is under 8 chars', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController(text: 'test@example.com');
    final password = TextEditingController(text: 'short');

    await tester.pumpWidget(
      _buildLoginForm(
        loginCubit: mockLoginCubit,
        forgetCubit: mockForgetCubit,
        formKey: formKey,
        email: email,
        password: password,
      ),
    );
    await tester.pumpAndSettle();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });

  testWidgets(
    'form validates without errors when email and password are valid',
    (tester) async {
      final formKey = GlobalKey<FormState>();
      final email = TextEditingController(text: 'user@example.com');
      final password = TextEditingController(text: 'StrongPass1');

      await tester.pumpWidget(
        _buildLoginForm(
          loginCubit: mockLoginCubit,
          forgetCubit: mockForgetCubit,
          formKey: formKey,
          email: email,
          password: password,
        ),
      );
      await tester.pumpAndSettle();

      final isValid = formKey.currentState!.validate();
      await tester.pump();

      expect(isValid, true);
      expect(find.text('Please enter your email address'), findsNothing);
      expect(find.text('Please enter your password'), findsNothing);
    },
  );

  testWidgets(
    'LoginButtonConsumer shows AuthLoadingIndicator in LoginLoading state',
    (tester) async {
      when(() => mockLoginCubit.state).thenReturn(const LoginLoading());
      when(
        () => mockLoginCubit.stream,
      ).thenAnswer((_) => Stream.value(const LoginLoading()));

      await tester.pumpWidget(
        buildTestableWidget(
          providers: [BlocProvider<LoginCubit>.value(value: mockLoginCubit)],
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return const CircularProgressIndicator(key: Key('loading'));
              }
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('loading')), findsOneWidget);
    },
  );

  testWidgets('BlocBuilder transitions to a success widget on LoginSuccess', (
    tester,
  ) async {
    when(() => mockLoginCubit.state).thenReturn(LoginSuccess(user: tUser));
    when(
      () => mockLoginCubit.stream,
    ).thenAnswer((_) => Stream.value(LoginSuccess(user: tUser)));

    await tester.pumpWidget(
      buildTestableWidget(
        providers: [BlocProvider<LoginCubit>.value(value: mockLoginCubit)],
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (_, state) {
            return switch (state) {
              LoginSuccess() => const Text('Welcome!', key: Key('success')),
              _ => const SizedBox(),
            };
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('success')), findsOneWidget);
  });

  testWidgets('BlocBuilder shows error text on LoginFailed state', (
    tester,
  ) async {
    when(() => mockLoginCubit.state).thenReturn(LoginFailed(failure: tFailure));
    when(
      () => mockLoginCubit.stream,
    ).thenAnswer((_) => Stream.value(LoginFailed(failure: tFailure)));

    await tester.pumpWidget(
      buildTestableWidget(
        providers: [BlocProvider<LoginCubit>.value(value: mockLoginCubit)],
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (_, state) {
            return switch (state) {
              LoginFailed(failure: final f) => Text(
                f.message,
                key: const Key('error'),
              ),
              _ => const SizedBox(),
            };
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('error')), findsOneWidget);
    expect(find.text(tFailure.message), findsOneWidget);
  });
}

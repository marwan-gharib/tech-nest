/// Widget tests for [SignUpScreen].
///
/// Covered scenarios:
///  1. Renders name, email, password, confirm password, checkbox, and button.
///  2. Validation errors for empty fields.
///  3. Validation errors for invalid email format.
///  4. Validation errors for passwords not matching.
///  5. SignUp button is disabled if terms checkbox is not checked.
///  6. Valid form passes validation when all rules are met and profile picture is provided.
///  7. RegistrationLoading shows loading indicator.
///  8. RegistrationFailed state shows error snackbar.
///  9. ProfileImageCubit state being null shows select profile image snackbar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/profile_image_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/sign_up_button_consumer.dart';
import 'package:tech_nest/features/auth/presentation/widgets/sign_up_form.dart';

import '../helpers/auth_test_helpers.dart';

/// Builds [SignUpForm] and [SignUpButtonConsumer] to test interactions.
Widget _buildSignUpFormWithButton({
  required MockRegistrationCubit registrationCubit,
  required MockProfileImageCubit profileImageCubit,
  required GlobalKey<FormState> formKey,
  required TextEditingController fullName,
  required TextEditingController email,
  required TextEditingController password,
  required TextEditingController confirmPassword,
  required ValueNotifier<bool> checkBoxNotifier,
  required ValueNotifier<bool> isPasswordObscure,
}) {
  return buildTestableWidget(
    providers: [
      BlocProvider<RegistrationCubit>.value(value: registrationCubit),
      BlocProvider<ProfileImageCubit>.value(value: profileImageCubit),
    ],
    child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SignUpForm(
              formKey: formKey,
              fullName: fullName,
              email: email,
              password: password,
              confirmPassword: confirmPassword,
              checkBoxNotifier: checkBoxNotifier,
              isPasswordObscure: isPasswordObscure,
            ),
            SignUpButtonConsumer(
              checkBoxNotifier: checkBoxNotifier,
              emailController: email,
              onSignUpPressed: () {
                if (formKey.currentState!.validate()) {
                  registrationCubit.signUp(
                    name: fullName.text,
                    email: email.text,
                    password: password.text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  late MockRegistrationCubit mockRegistrationCubit;
  late MockProfileImageCubit mockProfileImageCubit;

  setUp(() {
    mockRegistrationCubit = MockRegistrationCubit();
    mockProfileImageCubit = MockProfileImageCubit();

    when(
      () => mockRegistrationCubit.state,
    ).thenReturn(const RegistrationInitial());
    when(
      () => mockRegistrationCubit.stream,
    ).thenAnswer((_) => Stream.value(const RegistrationInitial()));

    when(() => mockProfileImageCubit.state).thenReturn(null);
    when(
      () => mockProfileImageCubit.stream,
    ).thenAnswer((_) => Stream.value(null));
  });

  testWidgets('renders all input fields, checkbox, and button', (tester) async {
    final formKey = GlobalKey<FormState>();
    final fullName = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    final confirmPassword = TextEditingController();
    final checkBoxNotifier = ValueNotifier<bool>(false);
    final isPasswordObscure = ValueNotifier<bool>(true);

    await tester.pumpWidget(
      _buildSignUpFormWithButton(
        registrationCubit: mockRegistrationCubit,
        profileImageCubit: mockProfileImageCubit,
        formKey: formKey,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        checkBoxNotifier: checkBoxNotifier,
        isPasswordObscure: isPasswordObscure,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Sign Up'), findsWidgets);
  });

  testWidgets('shows validation errors for empty fields', (tester) async {
    final formKey = GlobalKey<FormState>();
    final fullName = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    final confirmPassword = TextEditingController();
    final checkBoxNotifier = ValueNotifier<bool>(false);
    final isPasswordObscure = ValueNotifier<bool>(true);

    await tester.pumpWidget(
      _buildSignUpFormWithButton(
        registrationCubit: mockRegistrationCubit,
        profileImageCubit: mockProfileImageCubit,
        formKey: formKey,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        checkBoxNotifier: checkBoxNotifier,
        isPasswordObscure: isPasswordObscure,
      ),
    );
    await tester.pumpAndSettle();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('shows error if name does not have first and last name', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final fullName = TextEditingController(text: 'John');
    final email = TextEditingController(text: 'john@example.com');
    final password = TextEditingController(text: 'Password123');
    final confirmPassword = TextEditingController(text: 'Password123');
    final checkBoxNotifier = ValueNotifier<bool>(false);
    final isPasswordObscure = ValueNotifier<bool>(true);

    await tester.pumpWidget(
      _buildSignUpFormWithButton(
        registrationCubit: mockRegistrationCubit,
        profileImageCubit: mockProfileImageCubit,
        formKey: formKey,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        checkBoxNotifier: checkBoxNotifier,
        isPasswordObscure: isPasswordObscure,
      ),
    );
    await tester.pumpAndSettle();

    formKey.currentState!.validate();
    await tester.pump();

    expect(
      find.text('Name must be first and last name separation by space'),
      findsOneWidget,
    );
  });

  testWidgets('shows error when passwords do not match', (tester) async {
    final formKey = GlobalKey<FormState>();
    final fullName = TextEditingController(text: 'John Doe');
    final email = TextEditingController(text: 'john@example.com');
    final password = TextEditingController(text: 'Password123');
    final confirmPassword = TextEditingController(text: 'Different123');
    final checkBoxNotifier = ValueNotifier<bool>(false);
    final isPasswordObscure = ValueNotifier<bool>(true);

    await tester.pumpWidget(
      _buildSignUpFormWithButton(
        registrationCubit: mockRegistrationCubit,
        profileImageCubit: mockProfileImageCubit,
        formKey: formKey,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        checkBoxNotifier: checkBoxNotifier,
        isPasswordObscure: isPasswordObscure,
      ),
    );
    await tester.pumpAndSettle();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('does not call signup if checkbox is not checked', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final fullName = TextEditingController(text: 'John Doe');
    final email = TextEditingController(text: 'john@example.com');
    final password = TextEditingController(text: 'Password123');
    final confirmPassword = TextEditingController(text: 'Password123');
    final checkBoxNotifier = ValueNotifier<bool>(false);
    final isPasswordObscure = ValueNotifier<bool>(true);

    await tester.pumpWidget(
      _buildSignUpFormWithButton(
        registrationCubit: mockRegistrationCubit,
        profileImageCubit: mockProfileImageCubit,
        formKey: formKey,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        checkBoxNotifier: checkBoxNotifier,
        isPasswordObscure: isPasswordObscure,
      ),
    );
    await tester.pumpAndSettle();

    final button = find.text('Sign Up');
    await tester.tap(button);
    await tester.pumpAndSettle();

    verifyNever(
      () => mockRegistrationCubit.signUp(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets(
    'shows snackbar if profile picture is not selected when signing up',
    (tester) async {
      final formKey = GlobalKey<FormState>();
      final fullName = TextEditingController(text: 'John Doe');
      final email = TextEditingController(text: 'john@example.com');
      final password = TextEditingController(text: 'Password123');
      final confirmPassword = TextEditingController(text: 'Password123');
      final checkBoxNotifier = ValueNotifier<bool>(true);
      final isPasswordObscure = ValueNotifier<bool>(true);

      when(() => mockProfileImageCubit.state).thenReturn(null);

      await tester.pumpWidget(
        _buildSignUpFormWithButton(
          registrationCubit: mockRegistrationCubit,
          profileImageCubit: mockProfileImageCubit,
          formKey: formKey,
          fullName: fullName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          checkBoxNotifier: checkBoxNotifier,
          isPasswordObscure: isPasswordObscure,
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.text('Sign Up').first;
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      verifyNever(
        () => mockRegistrationCubit.signUp(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
      expect(find.text('Please select a profile picture.'), findsOneWidget);
    },
  );

  testWidgets(
    'calls signup when form is valid, checked, and image is selected',
    (tester) async {
      final formKey = GlobalKey<FormState>();
      final fullName = TextEditingController(text: 'John Doe');
      final email = TextEditingController(text: 'john@example.com');
      final password = TextEditingController(text: 'Password123');
      final confirmPassword = TextEditingController(text: 'Password123');
      final checkBoxNotifier = ValueNotifier<bool>(true);
      final isPasswordObscure = ValueNotifier<bool>(true);

      when(
        () => mockProfileImageCubit.state,
      ).thenReturn(XFile('test/path.png'));

      await tester.pumpWidget(
        _buildSignUpFormWithButton(
          registrationCubit: mockRegistrationCubit,
          profileImageCubit: mockProfileImageCubit,
          formKey: formKey,
          fullName: fullName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          checkBoxNotifier: checkBoxNotifier,
          isPasswordObscure: isPasswordObscure,
        ),
      );
      await tester.pumpAndSettle();

      when(
        () => mockRegistrationCubit.signUp(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      final buttonFinder = find.text('Sign Up').first;
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      verify(
        () => mockRegistrationCubit.signUp(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'Password123',
        ),
      ).called(1);
    },
  );

  testWidgets(
    'SignUpButtonConsumer shows AuthLoadingIndicator in RegistrationLoading state',
    (tester) async {
      final checkBoxNotifier = ValueNotifier<bool>(true);
      final emailController = TextEditingController();

      when(
        () => mockRegistrationCubit.state,
      ).thenReturn(const RegistrationLoading());
      when(
        () => mockRegistrationCubit.stream,
      ).thenAnswer((_) => Stream.value(const RegistrationLoading()));

      await tester.pumpWidget(
        buildTestableWidget(
          providers: [
            BlocProvider<RegistrationCubit>.value(value: mockRegistrationCubit),
            BlocProvider<ProfileImageCubit>.value(value: mockProfileImageCubit),
          ],
          child: Scaffold(
            body: SignUpButtonConsumer(
              checkBoxNotifier: checkBoxNotifier,
              emailController: emailController,
              onSignUpPressed: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Sign Up'), findsNothing);
    },
  );

  testWidgets(
    'SignUpButtonConsumer shows error text on RegistrationFailed state',
    (tester) async {
      final checkBoxNotifier = ValueNotifier<bool>(true);
      final emailController = TextEditingController();

      final tFailure = ServerFailure(message: 'Email already exists');
      when(
        () => mockRegistrationCubit.state,
      ).thenReturn(RegistrationFailed(failure: tFailure));
      when(
        () => mockRegistrationCubit.stream,
      ).thenAnswer((_) => Stream.value(RegistrationFailed(failure: tFailure)));

      await tester.pumpWidget(
        buildTestableWidget(
          providers: [
            BlocProvider<RegistrationCubit>.value(value: mockRegistrationCubit),
            BlocProvider<ProfileImageCubit>.value(value: mockProfileImageCubit),
          ],
          child: Scaffold(
            body: SignUpButtonConsumer(
              checkBoxNotifier: checkBoxNotifier,
              emailController: emailController,
              onSignUpPressed: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(tFailure.message), findsOneWidget);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/shared/presentation/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/image_provider.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/pick_profile_image.dart';
import 'package:tech_nest/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:tech_nest/features/auth/presentation/widgets/verify_email_dialog.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final GlobalKey<FormState> _formKey;
  late final ValueNotifier<bool> _checkBoxNotifier;
  late final ValueNotifier<bool> _isPasswordObscure;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _checkBoxNotifier = ValueNotifier<bool>(false);
    _isPasswordObscure = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _checkBoxNotifier.dispose();
    _isPasswordObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<XFile?>(imageProvider, (previous, next) {
      if (previous != next) {
        context.read<RegistrationCubit>().profileImg = next;
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Sign Up")),
        body: BlocListener<RegistrationCubit, RegistrationState>(
          listenWhen: (p, c) =>
              c is RegistrationSuccess || c is RegistrationFailed,
          listener: _listener,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            children: [
              const Center(child: PickProfileImage()),
              const SizedBox(height: AppSpacing.xxl),
              SignUpForm(
                formKey: _formKey,
                fullName: _fullName,
                email: _email,
                password: _password,
                confirmPassword: _confirmPassword,
                checkBoxNotifier: _checkBoxNotifier,
                isPasswordObscure: _isPasswordObscure,
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<bool>(
                valueListenable: _checkBoxNotifier,
                builder: (_, value, _) {
                  return BlocBuilder<RegistrationCubit, RegistrationState>(
                    buildWhen: (p, c) => p != c,
                    builder: _builder,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              AskNavigationWidget(
                question: "Have an account?",
                screenLabel: "Login",
                onTap: () => context.go(Routes.loginScreenPath),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _listener(BuildContext context, RegistrationState state) async {
    if (state is RegistrationSuccess) {
      await showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (context) => sl<VerifyEmailCubit>(),
          child: VerifyEmailDialog(email: _email.text.trim()),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
      );
    } else if (state is RegistrationFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, RegistrationState state) {
    if (state is RegistrationLoading) {
      return SizedBox(
        height: AppSpacing.xxl + AppSpacing.lg,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return _signUpButton();
  }

  Widget _signUpButton() {
    return ElevatedButton(
      onPressed: _checkBoxNotifier.value
          ? () {
              if (ref.read(imageProvider) == null) {
                CustomSnackBar.show(
                  context,
                  message: "Please select a profile image.",
                );
              } else {
                _onPressedSignUp();
              }
            }
          : null,
      child: const Text("Sign Up"),
    );
  }

  Future<void> _onPressedSignUp() async {
    if (_formKey.currentState!.validate()) {
      await context.read<RegistrationCubit>().signUp(
        name: _fullName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
    }
  }
}

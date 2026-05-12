import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/profile_image_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_header_section.dart';
import 'package:tech_nest/features/auth/presentation/widgets/pick_profile_image.dart';
import 'package:tech_nest/features/auth/presentation/widgets/sign_up_button_consumer.dart';
import 'package:tech_nest/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    final t = context.t.auth;

    return SafeArea(
      child: BlocProvider(
        create: (context) => ProfileImageCubit(),
        child: Scaffold(
          body: BlocListener<ProfileImageCubit, XFile?>(
            listener: (context, img) {
              context.read<RegistrationCubit>().profileImg = img;
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  AuthHeaderSection(headline: t.signUp),
                  const SizedBox(height: AppSpacing.xl),
                  const Center(child: PickProfileImage()),
                  const SizedBox(height: AppSpacing.lg),
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
                  SignUpButtonConsumer(
                    checkBoxNotifier: _checkBoxNotifier,
                    emailController: _email,
                    onSignUpPressed: _onPressedSignUp,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AskNavigationWidget(
                    question: t.alreadyHaveAccount,
                    screenLabel: t.login,
                    onTap: () => context.goNamed(RouteNames.login),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressedSignUp() async {
    if (_formKey.currentState!.validate()) {
      await context.read<RegistrationCubit>().signUp(
        name: _fullName.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );
    }
  }
}

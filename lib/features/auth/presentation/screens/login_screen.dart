import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/validators.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_header_section.dart';
import 'package:tech_nest/features/auth/presentation/widgets/login_button_consumer.dart';
import 'package:tech_nest/features/auth/presentation/widgets/login_form.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final GlobalKey<FormState> _formKey;
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _authNotifier = sl<AuthNotifier>();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              AuthHeaderSection(headline: t.login),
              const SizedBox(height: AppSpacing.xxl),
              LoginForm(
                formKey: _formKey,
                email: _email,
                password: _password,
                onForgetPass: _onTappedForgetPass,
              ),
              const SizedBox(height: AppSpacing.lg),
              LoginButtonConsumer(
                authNotifier: _authNotifier,
                onPressed: _onPressedLogin,
              ),
              const SizedBox(height: AppSpacing.xl),
              AskNavigationWidget(
                question: t.dontHaveAccount,
                screenLabel: t.signUp,
                onTap: () => context.goNamed(RouteNames.signUp),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPressedLogin() async {
    if (_formKey.currentState!.validate()) {
      await context.read<LoginCubit>().login(
        email: _email.text.trim(),
        password: _password.text,
      );
    }
  }

  Future<void> _onTappedForgetPass() async {
    if (Validators.emailValidator(_email.text) == null) {
      await context.read<ForgetPasswordCubit>().forgetPassword(
        email: _email.text,
      );
    } else {
      CustomSnackBar.show(context, message: context.t.auth.resetPasswordPrompt);
    }
  }
}

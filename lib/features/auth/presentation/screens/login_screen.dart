import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/shared/utils/validators.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/login_button_consumer.dart';
import 'package:tech_nest/features/auth/presentation/widgets/login_form.dart';
import 'package:tech_nest/features/auth/presentation/widgets/reset_password_dialog.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(context.t.auth.login)),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xxl,
          ),
          children: [
            LoginForm(
              formKey: _formKey,
              email: _email,
              password: _password,
              onForgetPass: _onTappedForgetPass,
              forgetPasswordListener: _forgetPasswordListener,
            ),
            const SizedBox(height: AppSpacing.md),
            BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
              listenWhen: (p, c) => c is ForgetPasswordFailed,
              listener: (context, state) {
                if (state is ForgetPasswordFailed) {
                  CustomSnackBar.showError(context, failure: state.failure);
                }
              },
              child: const SizedBox.shrink(),
            ),
            LoginButtonConsumer(
              authNotifier: _authNotifier,
              onPressed: _onPressedLogin,
            ),
            const SizedBox(height: AppSpacing.xl),
            AskNavigationWidget(
              question: context.t.auth.dontHaveAccount,
              screenLabel: context.t.auth.signUp,
              onTap: () => context.go(Routes.signUpScreenPath),
            ),
          ],
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

  Future<void> _forgetPasswordListener(
    BuildContext context,
    ForgetPasswordState state,
  ) async {
    if (state is ForgetPasswordLoading) {
      _showLoadingDialog(context);
    } else if (state is ForgetPasswordSuccess) {
      context.pop();
      await showDialog(
        context: context,
        builder: (context) => BlocProvider(
          create: (context) => sl<ResetPasswordCubit>(),
          child: ResetPasswordDialog(email: _email.text),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
      );
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: context.t.auth.resetPasswordSuccess,
          isAbove: true,
        );
      }
    }
  }

  void _showLoadingDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      dialogType: DialogType.noHeader,
      body: Center(
        child: SpinKitWaveSpinner(color: Theme.of(context).colorScheme.primary),
      ),
    ).show();
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/validators.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/forget_password_dialoge.dart';
import 'package:tech_nest/features/auth/presentation/widgets/login_form.dart';

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Login")),
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
              listener: (context, state) {
                if (state is ForgetPasswordFailed) {
                  CustomSnackBar.showError(context, failure: state.failure);
                }
              },
              child: const SizedBox.shrink(),
            ),
            BlocConsumer<LoginCubit, LoginState>(
              listener: _loginListener,
              builder: _loginBuilder,
            ),
            const SizedBox(height: AppSpacing.xl),
            AskNavigationWidget(
              question: "Don't have an account ? ",
              screenLabel: "registration",
              onTap: () => context.go(Routes.signUpScreenPath),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginListener(BuildContext context, LoginState state) async {
    if (state is LoginSuccess) {
      _authNotifier.login();
    } else if (state is LoginFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _loginBuilder(BuildContext context, LoginState state) {
    if (state is LoginLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return ElevatedButton(
      onPressed: _onPressedLogin,
      child: const Text("Login"),
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
      CustomSnackBar.show(context, message: "Please enter a valid email first");
    }
  }

  void _forgetPasswordListener(
    BuildContext context,
    ForgetPasswordState state,
  ) async {
    if (state is ForgetPasswordFailed) {
      context.pop(); // this pop for loading dialoge , pop it when failed
      CustomSnackBar.showError(context, failure: state.failure);
    } else if (state is ForgetPasswordLoading) {
      _showLoadingDialog(context);
    } else if (state is ForgetPasswordSuccess) {
      context.pop();
      await showDialog(
        context: context,
        builder: (dialogeContext) => BlocProvider(
          create: (context) => sl<ResetPasswordCubit>(),
          child: ForgetPasswordDialoge(
            dialogeContext: dialogeContext,
            email: _email.text,
          ),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: false,
      );
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: "Password changed Successfully",
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

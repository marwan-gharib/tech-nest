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
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/forget_password_dialoge.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  late final GlobalKey<FormState> _emailFormKey;
  late final GlobalKey<FormState> _passFormKey;
  //
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    _emailFormKey = GlobalKey<FormState>();
    _passFormKey = GlobalKey<FormState>();

    _authNotifier = sl<AuthNotifier>();

    super.initState();
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
            Form(
              key: _emailFormKey,
              child: CustomInputField(
                controller: _email,
                lable: "E-mail Address",
                hint: "example@email.com",
                keyboardType: TextInputType.emailAddress,
                validator: Validators.emailValidator,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Form(
              key: _passFormKey,
              child: CustomInputField(
                controller: _password,
                lable: "Password",
                hint: "* " * 8,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: Validators.passwordValidator,
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerEnd,
              heightFactor: 1.5,
              child: GestureDetector(
                onTap: _onTappedForgetPass,
                child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
                  listener: _forgetPasswordListener,
                  child: Text(
                    "Forget password",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
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

  Future<void> _forgetPasswordListener(
    BuildContext context,
    ForgetPasswordState state,
  ) async {
    if (state is ForgetPasswordFailed) {
      customSnackBar(context, message: state.message);
    } else if (state is ForgetPasswordLoading) {
      showLoadingDialog(context);
    } else if (state is ForgetPasswordSuccess) {
      context.pop();
      await showDialog(
        context: context,
        builder: (context) => BlocProvider(
          create: (context) => sl<ResetPasswordCubit>(),
          child: ForgetPasswordDialoge(email: _email.text),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
      );
      if (context.mounted) {
        customSnackBar(
          context,
          message: "Password changed Successfully",
          isAbove: true,
        );
      }
    }
  }

  Future<void> _loginListener(BuildContext context, LoginState state) async {
    if (state is LoginSuccess) {
      _authNotifier.login();
    } else if (state is LoginFailed) {
      customSnackBar(context, message: state.message);
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

  void showLoadingDialog(BuildContext context) {
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

  Future<void> _onPressedLogin() async {
    final emailValidation = _emailFormKey.currentState!.validate();
    final passValidation = _passFormKey.currentState!.validate();

    if (emailValidation && passValidation) {
      await context.read<LoginCubit>().login(
        email: _email.text.trim(),
        password: _password.text,
      );
    }
  }

  Future<void> _onTappedForgetPass() async {
    if (_emailFormKey.currentState!.validate()) {
      await context.read<ForgetPasswordCubit>().forgetPassword(
        email: _email.text,
      );
    }
  }
}

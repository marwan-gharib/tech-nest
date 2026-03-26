import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/validators.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_partition_dialoge.dart';

class ForgetPasswordDialoge extends StatefulWidget {
  final String email;
  const ForgetPasswordDialoge({required this.email, super.key});

  @override
  State<ForgetPasswordDialoge> createState() => _ForgetPasswordDialogeState();
}

class _ForgetPasswordDialogeState extends State<ForgetPasswordDialoge> {
  late final TextEditingController _code;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  late final ValueNotifier<bool> _isErrNotifire;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _code = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    _isErrNotifire = ValueNotifier<bool>(false);

    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    _isErrNotifire.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 400),
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInExpo,
        builder: (context, value, child) =>
            Transform.scale(scale: value, child: child),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Theme.of(context).shadowColor),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomPartitionDialoge(
                    pinCodeController: _code,
                    isErrNotifire: _isErrNotifire,
                    label: "Reset Password",
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomInputField(
                    controller: _password,
                    label: "Password",
                    hint: "* " * 8,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: Validators.passwordValidator,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomInputField(
                    controller: _confirmPassword,
                    label: "Confirm Password",
                    hint: "* " * 8,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: (value) => Validators.confirmPasswordValidator(
                      value,
                      password: _password.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                    listener: _forgetPassListener,
                    builder: _forgetPassBuilder,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _forgetPassListener(BuildContext context, ResetPasswordState state) {
    if (state is ResetPasswordSuccess) {
      context.pop();
    } else if (state is ResetPasswordFailed) {
      _isErrNotifire.value = true;
    } else if (state is ResetPasswordSuccess || state is ResetPasswordLoading) {
      _isErrNotifire.value = false;
    }
  }

  Widget _forgetPassBuilder(BuildContext context, ResetPasswordState state) {
    if (state is ResetPasswordLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return ElevatedButton(
      onPressed: _code.text.length < 6 ? null : _onButtonPressed,
      child: const Text("Reset password"),
    );
  }

  Future<void> _onButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      await context.read<ResetPasswordCubit>().resetPassword(
        email: widget.email,
        code: _code.text,
        newPass: _password.text,
      );
    }
  }
}

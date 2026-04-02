import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/auth_constants.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/shared/utils/extensions/localization_extension.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_pin_code_dialog.dart';
import 'package:tech_nest/features/auth/presentation/widgets/reset_password_form_fields.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String email;
  const ResetPasswordDialog({required this.email, super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  late final TextEditingController _code;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  late final ValueNotifier<bool> _isErrNotifire;

  late final GlobalKey<FormState> _formKey;
  late final ValueNotifier<bool> _isPasswordObscure;

  @override
  void initState() {
    _code = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    _isErrNotifire = ValueNotifier<bool>(false);
    _isPasswordObscure = ValueNotifier<bool>(true);

    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    _isErrNotifire.dispose();
    _isPasswordObscure.dispose();

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
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Theme.of(context).shadowColor),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomPinCodeDialog(
                    pinCodeController: _code,
                    isErrNotifire: _isErrNotifire,
                    label: "Reset Password",
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ResetPasswordFormFields(
                    passwordController: _password,
                    confirmPasswordController: _confirmPassword,
                    isPasswordObscure: _isPasswordObscure,
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
      // no showing snack bar here
    } else if (state is ResetPasswordLoading) {
      _isErrNotifire.value = false;
    }
  }

  Widget _forgetPassBuilder(BuildContext context, ResetPasswordState state) {
    if (state is ResetPasswordLoading) {
      return SizedBox(
        height: AppSpacing.xxl + AppSpacing.lg,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: _code.text.length < AuthConstants.verificationPinLength
          ? null
          : _onButtonPressed,
      child: Text(context.l10n.authResetPasswordButton),
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

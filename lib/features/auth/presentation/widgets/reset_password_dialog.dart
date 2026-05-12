import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_dialog_shell.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_pin_code_dialog.dart';
import 'package:tech_nest/features/auth/presentation/widgets/reset_password_form_fields.dart';
import 'package:tech_nest/i18n/strings.g.dart';

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
    return AuthDialogShell(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPinCodeDialog(
                pinCodeController: _code,
                isErrNotifire: _isErrNotifire,
                label: context.t.auth.resetPassword,
                hint: context.t.auth.enterCode,
                errorText: context.t.auth.invalidCode,
              ),
              const SizedBox(height: AppSpacing.lg),
              ResetPasswordFormFields(
                passwordController: _password,
                confirmPasswordController: _confirmPassword,
                isPasswordObscure: _isPasswordObscure,
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                listener: _resetPassListener,
                builder: _resetPassBuilder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassListener(BuildContext context, ResetPasswordState state) {
    if (state is ResetPasswordSuccess) {
      context.pop(true);
    } else if (state is ResetPasswordFailed) {
      _isErrNotifire.value = true;
    } else if (state is ResetPasswordLoading) {
      _isErrNotifire.value = false;
    }
  }

  Widget _resetPassBuilder(BuildContext context, ResetPasswordState state) {
    if (state is ResetPasswordLoading) return const AuthLoadingIndicator();
    return ElevatedButton(
      onPressed: _onButtonPressed,
      child: Text(context.t.auth.resetPassword),
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

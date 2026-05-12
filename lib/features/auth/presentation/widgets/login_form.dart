import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/utils/validators.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/reset_password_dialog.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final VoidCallback onForgetPass;

  const LoginForm({
    required this.formKey,
    required this.email,
    required this.password,
    required this.onForgetPass,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInSlide(
            delay: const Duration(milliseconds: 100),
            child: CustomInputField(
              controller: email,
              label: context.t.auth.email,
              hint: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: Validators.emailValidator,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeInSlide(
            delay: const Duration(milliseconds: 200),
            child: CustomInputField(
              controller: password,
              label: context.t.auth.password,
              hint: '* ' * 8,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: Validators.passwordValidator,
            ),
          ),
          FadeInSlide(
            delay: const Duration(milliseconds: 300),
            child: Align(
              alignment: AlignmentGeometry.centerEnd,
              heightFactor: 1.5,
              child: GestureDetector(
                onTap: onForgetPass,
                child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
                  listener: _forgetPasswordListener,
                  child: Text(
                    context.t.auth.forgotPassword,
                    style: context.labelMedium.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _forgetPasswordListener(
    BuildContext context,
    ForgetPasswordState state,
  ) async {
    if (state is ForgetPasswordLoading) {
      _showLoadingDialog(context);
    } else if (state is ForgetPasswordSuccess) {
      context.pop();
      final bool? isSuccess = await showDialog<bool?>(
        context: context,
        builder: (context) => BlocProvider(
          create: (context) => sl<ResetPasswordCubit>(),
          child: ResetPasswordDialog(email: email.text),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
      );
      if (context.mounted && (isSuccess ?? false)) {
        CustomSnackBar.show(
          context,
          message: context.t.auth.resetPasswordSuccess,
        );
      }
    } else if (state is ForgetPasswordFailed) {
      context.pop();
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      dialogType: DialogType.noHeader,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: SpinKitWaveSpinner(color: context.colorScheme.primary),
        ),
      ),
    ).show();
  }
}

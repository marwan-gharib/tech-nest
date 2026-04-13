import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/shared/utils/validators.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class ResetPasswordFormFields extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueNotifier<bool> isPasswordObscure;

  const ResetPasswordFormFields({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordObscure,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPasswordObscure,
      builder: (context, obscure, child) {
        return Column(
          children: [
            CustomInputField(
              controller: passwordController,
              label: context.t.auth.password,
              hint: "* " * 8,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              isObscure: obscure,
              onVisibilityToggle: () =>
                  isPasswordObscure.value = !isPasswordObscure.value,
              validator: Validators.passwordValidator,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomInputField(
              controller: confirmPasswordController,
              label: context.t.auth.confirmPassword,
              hint: "* " * 8,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              isObscure: obscure,
              validator: (value) => Validators.confirmPasswordValidator(
                value,
                password: passwordController.text,
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/validators.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/privacy_policy_widget.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullName;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final ValueNotifier<bool> checkBoxNotifier;
  final ValueNotifier<bool> isPasswordObscure;

  const SignUpForm({
    required this.formKey,
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.checkBoxNotifier,
    required this.isPasswordObscure,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          FadeInSlide(
            delay: const Duration(milliseconds: 100),
            child: CustomInputField(
              controller: fullName,
              label: context.t.auth.fullName,
              hint: context.t.auth.enterName,
              keyboardType: TextInputType.name,
              prefixIcon: Icons.person_outline,
              validator: Validators.fullNameValidator,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeInSlide(
            delay: const Duration(milliseconds: 200),
            child: CustomInputField(
              controller: email,
              label: context.t.auth.email,
              hint: context.t.auth.emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: Validators.emailValidator,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ValueListenableBuilder<bool>(
            valueListenable: isPasswordObscure,
            builder: (context, obscure, child) {
              return Column(
                children: [
                  FadeInSlide(
                    delay: const Duration(milliseconds: 300),
                    child: CustomInputField(
                      controller: password,
                      label: context.t.auth.password,
                      hint: '* ' * 8,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      isObscure: obscure,
                      onVisibilityToggle: () =>
                          isPasswordObscure.value = !isPasswordObscure.value,
                      validator: Validators.passwordValidator,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeInSlide(
                    delay: const Duration(milliseconds: 400),
                    child: CustomInputField(
                      controller: confirmPassword,
                      label: context.t.auth.confirmPassword,
                      hint: '* ' * 8,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_open_outlined,
                      isPassword: true,
                      isObscure: obscure,
                      validator: (value) =>
                          Validators.confirmPasswordValidator(
                        value,
                        password: password.text,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeInSlide(
            delay: const Duration(milliseconds: 500),
            child: PrivacyPolicyWidget(checkBoxNotifier),
          ),
        ],
      ),
    );
  }
}

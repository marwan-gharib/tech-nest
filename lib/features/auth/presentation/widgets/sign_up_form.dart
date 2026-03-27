import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/validators.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/privacy_policy_widget.dart';

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
          CustomInputField(
            controller: fullName,
            label: "Full Name",
            hint: "Enter your name",
            keyboardType: TextInputType.name,
            validator: Validators.fullNameValidator,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomInputField(
            controller: email,
            label: "E-mail Address",
            hint: "example@email.com",
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator,
          ),
          const SizedBox(height: AppSpacing.lg),
          ValueListenableBuilder(
            valueListenable: isPasswordObscure,
            builder: (context, obscure, child) {
              return Column(
                children: [
                  CustomInputField(
                    controller: password,
                    label: "Password",
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
                    controller: confirmPassword,
                    label: "Confirm Password",
                    hint: "* " * 8,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    isObscure: obscure,
                    validator: (value) => Validators.confirmPasswordValidator(
                      value,
                      password: password.text,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          PrivacyPolicyWidget(checkBoxNotifier),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/shared/utils/validators.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final VoidCallback onForgetPass;
  final BlocWidgetListener<ForgetPasswordState> forgetPasswordListener;

  const LoginForm({
    required this.formKey,
    required this.email,
    required this.password,
    required this.onForgetPass,
    required this.forgetPasswordListener,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInputField(
            controller: email,
            label: "E-mail Address",
            hint: "example@email.com",
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomInputField(
            controller: password,
            label: "Password",
            hint: "* " * 8,
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
            validator: Validators.passwordValidator,
          ),
          Align(
            alignment: AlignmentGeometry.centerEnd,
            heightFactor: 1.5,
            child: GestureDetector(
              onTap: onForgetPass,
              child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
                listener: forgetPasswordListener,
                child: Text(
                  "Forget password",
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

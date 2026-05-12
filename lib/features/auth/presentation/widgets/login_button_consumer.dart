import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/widgets/app_button.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class LoginButtonConsumer extends StatelessWidget {
  final AuthNotifier authNotifier;
  final VoidCallback onPressed;

  const LoginButtonConsumer({
    required this.authNotifier,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (p, c) => c is LoginSuccess || c is LoginFailed,
      listener: (context, state) {
        if (state is LoginSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) authNotifier.login();
          });
        } else if (state is LoginFailed) {
          if (context.mounted) {
            CustomSnackBar.showError(context, failure: state.failure);
          }
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) return const AuthLoadingIndicator();
        return AppButton(onTap: onPressed, text: context.t.auth.login);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/widgets/app_button.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/profile_image_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:tech_nest/features/auth/presentation/widgets/verify_email_dialog.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class SignUpButtonConsumer extends StatelessWidget {
  final ValueNotifier<bool> checkBoxNotifier;
  final TextEditingController emailController;
  final VoidCallback onSignUpPressed;

  const SignUpButtonConsumer({
    required this.checkBoxNotifier,
    required this.emailController,
    required this.onSignUpPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: checkBoxNotifier,
      builder: (_, isChecked, _) {
        return BlocConsumer<RegistrationCubit, RegistrationState>(
          buildWhen: (p, c) => p != c,
          listenWhen: (p, c) =>
              c is RegistrationSuccess || c is RegistrationFailed,
          listener: _listener,
          builder: (context, state) {
            if (state is RegistrationLoading) {
              return const AuthLoadingIndicator();
            }
            return AppButton(
              onTap: () => _onButtonTap(context),
              text: context.t.auth.signUp,
              isEnabled: isChecked,
            );
          },
        );
      },
    );
  }

  void _onButtonTap(BuildContext context) {
    final profileImg = context.read<ProfileImageCubit>().state;
    if (profileImg == null) {
      CustomSnackBar.show(context, message: context.t.auth.selectProfileImage);
    } else {
      onSignUpPressed();
    }
  }

  Future<void> _listener(BuildContext context, RegistrationState state) async {
    if (state is RegistrationSuccess) {
      await showDialog<bool?>(
        context: context,
        builder: (_) => BlocProvider(
          create: (context) => sl<VerifyEmailCubit>(),
          child: VerifyEmailDialog(email: emailController.text.trim()),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
      );
    } else if (state is RegistrationFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }
}

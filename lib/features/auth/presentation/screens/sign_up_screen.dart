import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/app_button.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/profile_image_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/pick_profile_image.dart';
import 'package:tech_nest/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:tech_nest/features/auth/presentation/widgets/verify_email_dialog.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final GlobalKey<FormState> _formKey;
  late final ValueNotifier<bool> _checkBoxNotifier;
  late final ValueNotifier<bool> _isPasswordObscure;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _checkBoxNotifier = ValueNotifier<bool>(false);
    _isPasswordObscure = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _checkBoxNotifier.dispose();
    _isPasswordObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ProfileImageCubit(),
        child: Scaffold(
          appBar: AppBar(title: Text(context.t.auth.signUp)),
          body: BlocListener<ProfileImageCubit, XFile?>(
            listener: (context, img) {
              context.read<RegistrationCubit>().profileImg = img;
            },

            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              children: [
                const Center(child: PickProfileImage()),
                const SizedBox(height: AppSpacing.xxl),
                SignUpForm(
                  formKey: _formKey,
                  fullName: _fullName,
                  email: _email,
                  password: _password,
                  confirmPassword: _confirmPassword,
                  checkBoxNotifier: _checkBoxNotifier,
                  isPasswordObscure: _isPasswordObscure,
                ),
                const SizedBox(height: AppSpacing.md),
                ValueListenableBuilder<bool>(
                  valueListenable: _checkBoxNotifier,
                  builder: (_, value, _) {
                    return BlocConsumer<RegistrationCubit, RegistrationState>(
                      buildWhen: (p, c) => p != c,
                      listenWhen: (p, c) =>
                          c is RegistrationSuccess || c is RegistrationFailed,
                      listener: _listener,
                      builder: _builder,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                AskNavigationWidget(
                  question: context.t.auth.alreadyHaveAccount,
                  screenLabel: context.t.auth.login,
                  onTap: () => context.goNamed(RouteNames.login),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _listener(BuildContext context, RegistrationState state) async {
    if (state is RegistrationSuccess) {
      final bool? isSuccess = await showDialog<bool?>(
        context: context,
        builder: (_) => BlocProvider(
          create: (context) => sl<VerifyEmailCubit>(),
          child: VerifyEmailDialog(email: _email.text.trim()),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
      );

      if (context.mounted && (isSuccess ?? false)) {
        CustomSnackBar.show(
          context,
          message: context.t.auth.verifyEmailSuccess,
        );
      }
    } else if (state is RegistrationFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, RegistrationState state) {
    if (state is RegistrationLoading) {
      return SizedBox(
        height: AppSpacing.xxl + AppSpacing.lg,
        child: Center(
          child: CircularProgressIndicator(color: context.colorScheme.primary),
        ),
      );
    }

    return _signUpButton(context);
  }

  Widget _signUpButton(BuildContext context) {
    return AppButton(
      onTap: () {
        if (context.read<ProfileImageCubit>().state == null) {
          CustomSnackBar.show(
            context,
            message: context.t.auth.selectProfileImage,
          );
        } else {
          _onPressedSignUp();
        }
      },
      text: context.t.auth.signUp,
      isEnabled: _checkBoxNotifier.value,
    );
  }

  Future<void> _onPressedSignUp() async {
    if (_formKey.currentState!.validate()) {
      await context.read<RegistrationCubit>().signUp(
        name: _fullName.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );
    }
  }
}

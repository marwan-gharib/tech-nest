import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/router/routers.dart';
import 'package:tech_nest/core/state/image/image_provider.dart';
import 'package:tech_nest/core/utils/functions/validatiors.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registeration_cubit/registeration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/pick_profile_image.dart';
import 'package:tech_nest/features/auth/presentation/widgets/privacy_policy_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/verify_email_dialoge.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  late final GlobalKey<FormState> _formKey;

  late final ValueNotifier<bool> _checkBoxNotifire;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    _formKey = GlobalKey<FormState>();

    _checkBoxNotifire = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    super.dispose();
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    _checkBoxNotifire.dispose();

    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<XFile?>(imageProvider, (previous, next) {
      if (previous != next) {
        context.read<RegisterationCubit>().profileImg = next;
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Registeration")),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            children: [
              const Center(child: PickProfileImage()),
              const SizedBox(height: 50),
              CustomInputField(
                controller: _fullName,
                lable: "Full Name",
                hint: "Enter your name",
                keyboardType: TextInputType.name,
                validator: fullNameValditor,
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _email,
                lable: "E-mail Address",
                hint: "example@email.com",
                keyboardType: TextInputType.emailAddress,
                validator: emailValditor,
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _password,
                lable: "Password",
                hint: "* " * 8,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: passwordValditor,
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _confirmPassword,
                lable: "Confirm Password",
                hint: "* " * 8,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: (value) =>
                    confirmPasswordValditor(value, password: _password.text),
              ),
              const SizedBox(height: 40),
              PrivacyPolicyWidget(_checkBoxNotifire),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: _checkBoxNotifire,
                builder: (_, value, _) {
                  return BlocConsumer<RegisterationCubit, RegisterationState>(
                    listener: _listener,
                    builder: _builder,
                  );
                },
              ),
              const SizedBox(height: 32),
              AskNavigationWidget(
                question: "Have an acount ? ",
                screenLabel: "Login",
                onTap: () => context.go(Routers.loginScreenPath),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _listener(BuildContext context, RegisterationState state) async {
    if (state is RegisterationSuccess) {
      await showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (context) => sl<VerifyEmailCubit>(),
          child: VerifyEmailDialoge(email: _email.text.trim()),
        ),
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
      );
    } else if (state is RegisterationFailed) {
      customSnackBar(context, message: state.message);
    }
  }

  Widget _builder(BuildContext context, RegisterationState state) {
    if (state is RegisterationLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return ElevatedButton(
      onPressed: _checkBoxNotifire.value
          ? () {
              if (ref.read(imageProvider) == null) {
                customSnackBar(
                  context,
                  message: "Profile Picture is required.",
                );
              } else {
                _onPressedSignUp();
              }
            }
          : null,
      child: const Text("Sign Up"),
    );
  }

  Future<void> _onPressedSignUp() async {
    if (_formKey.currentState!.validate()) {
      await context.read<RegisterationCubit>().signUp(
        name: _fullName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
    }
  }
}

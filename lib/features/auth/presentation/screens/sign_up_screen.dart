import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registeration_cubit/registeration_cubit.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/ask_navigation_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/auth/presentation/widgets/privacy_policy_widget.dart';
import 'package:tech_nest/features/auth/presentation/widgets/verify_email_dialoge.dart';

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

  late final ValueNotifier<bool> _checkBoxNotifire;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController(text: "Marwan Gharib");
    _email = TextEditingController(text: "marwanghareeb18@gmail.com");
    _password = TextEditingController(text: "12345678");
    _confirmPassword = TextEditingController(text: "12345678");

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Registeration")),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            children: [
              const SizedBox(height: 50),
              CustomInputField(
                controller: _fullName,
                lable: "Full Name",
                hint: "Enter your name",
                keyboardType: TextInputType.name,
                validator: _fullNameValditor,
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _email,
                lable: "E-mail Address",
                hint: "example@email.com",
                keyboardType: TextInputType.emailAddress,
                validator: _emailValditor,
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _password,
                lable: "Password",
                hint: "* " * 8,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: _passwordValditor,
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _confirmPassword,
                lable: "Confirm Password",
                hint: "* " * 8,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: _confirmPasswordValditor,
              ),
              const SizedBox(height: 40),
              PrivacyPolicyWidget(_checkBoxNotifire),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: _checkBoxNotifire,
                builder: (_, value, _) {
                  return BlocConsumer<RegisterationCubit, RegisterationState>(
                    listener: (context, state) async {
                      if (state is RegisterationSuccess) {
                        await showDialog(
                          context: context,
                          builder: (_) => BlocProvider(
                            create: (context) => sl<VerifyEmailCubit>(),
                            child: VerifyEmailDialoge(
                              email: _email.text.trim(),
                            ),
                          ),
                          barrierDismissible: false,
                          useSafeArea: true,
                          useRootNavigator: true,
                        );
                      } else if (state is RegisterationFailed) {
                        customSnackBar(context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is RegisterationLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }
                      return ElevatedButton(
                        onPressed: value ? _onPressedSignUp : null,
                        child: const Text("Sign Up"),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              AskNavigationWidget(
                question: "Have an acount ? ",
                screenLabel: "Login",
                onTap: () {},
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String? _fullNameValditor(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Please enter your name";
      }
      if (value.trim().split(" ").length != 2) {
        return "Name must be first and last name separation by space";
      }
    }
    return null;
  }

  String? _emailValditor(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    } else if (!EmailValidator.validate(_email.text)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? _passwordValditor(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    } else if (_password.text.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  String? _confirmPasswordValditor(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    } else if (value != _password.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> _onPressedSignUp() async {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterationCubit>().signUp(
        name: _fullName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
    }
  }
}

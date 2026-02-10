import 'package:tech_nest/core/constants/links.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/demo_screen.dart';
import 'package:tech_nest/features/auth/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

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

  late final ValueNotifier<bool> _checkBoxValue;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    _formKey = GlobalKey<FormState>();

    _checkBoxValue = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    super.dispose();
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    _checkBoxValue.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            children: [
              Center(
                child: Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SizedBox(height: 50),
              CustomInputField(
                controller: _fullName,
                lable: "Full Name",
                hint: "Enter your name",
                keyboardType: TextInputType.name,
                validator: _fullNameValditor,
              ),
              CustomInputField(
                controller: _email,
                lable: "E-mail Address",
                hint: "example@email.com",
                keyboardType: TextInputType.emailAddress,
                validator: _emailValditor,
              ),
              CustomInputField(
                controller: _password,
                lable: "Password",
                hint: "* " * 8,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: _passwordValditor,
              ),
              CustomInputField(
                controller: _confirmPassword,
                lable: "Confirm Password",
                hint: "* " * 8,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: _confirmPasswordValditor,
              ),
              SizedBox(height: 26),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _checkBoxValue,
                    builder: (_, value, child) {
                      return Checkbox(
                        value: value,
                        onChanged: (value) => _checkBoxValue.value = value!,
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                          strokeAlign: 3,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'By Creating an Account, i accept Hiring Hub ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        _textLink("Terms of Use", Links.termaAndConditionsLink),
                        Text(
                          ' and ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        _textLink("Privacy Policy", Links.privacyPolicyLink),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: _checkBoxValue,
                builder: (_, value, _) {
                  return BlocConsumer<SignUpCubit, SignUpState>(
                    listener: (context, state) {
                      if (state is SignUpSuccess) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DemoScreen(),
                            ),
                            (route) => true,
                          ),
                        );
                      } else if (state is SignUpFailed) {
                        customSnackBar(context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is SignUpLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }
                      return ElevatedButton(
                        onPressed: !value ? null : _onPressedSignUp,
                        child: Text("Sign Up"),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an Account?  "),
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _textLink(String text, String link) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(link));
      },
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _onPressedSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<SignUpCubit>().signUp(
        name: _fullName.text,
        email: _email.text,
        password: _password.text,
      );
    }
  }

  String? _fullNameValditor(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
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
}

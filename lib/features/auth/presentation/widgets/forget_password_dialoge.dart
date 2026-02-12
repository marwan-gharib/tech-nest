import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/utils/functions/validatiors.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_input_field.dart';

class ForgetPasswordDialoge extends StatefulWidget {
  final String email;
  const ForgetPasswordDialoge({required this.email, super.key});

  @override
  State<ForgetPasswordDialoge> createState() => _ForgetPasswordDialogeState();
}

class _ForgetPasswordDialogeState extends State<ForgetPasswordDialoge> {
  late final TextEditingController _code;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  late final ValueNotifier<bool> _isErrNotifire;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _code = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    _isErrNotifire = ValueNotifier<bool>(false);

    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    _isErrNotifire.dispose();

    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 400),
      alignment: Alignment.center,
      backgroundColor: AppColors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInExpo,
        builder: (context, value, child) =>
            Transform.scale(scale: value, child: child),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Theme.of(context).shadowColor),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        "Reset Password",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      "Enter code",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Pinput(
                    controller: _code,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    length: 6,
                    animationCurve: Curves.linear,
                    animationDuration: const Duration(milliseconds: 200),
                    autofocus: true,
                    defaultPinTheme: PinTheme(
                      margin: const EdgeInsets.all(2),
                      width: 35,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ValueListenableBuilder(
                    valueListenable: _isErrNotifire,
                    builder: (context, value, child) {
                      if (!value) return SizedBox.fromSize();
                      return Text(
                        "Invalid verification code",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
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
                    validator: (value) => confirmPasswordValditor(
                      value,
                      password: _password.text,
                    ),
                  ),
                  const SizedBox(height: 50),
                  BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                    listener: (context, state) async {
                      if (state is ResetPasswordSuccess) {
                        _isErrNotifire.value = false;
                        context.pop();
                      } else if (state is ResetPasswordFailed) {
                        _isErrNotifire.value = true;
                      }
                    },
                    builder: (context, state) {
                      if (state is ResetPasswordLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }
                      return ElevatedButton(
                        onPressed: _code.text.isEmpty
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<ResetPasswordCubit>()
                                      .resetPassword(
                                        email: widget.email,
                                        code: _code.text,
                                        newPass: _password.text,
                                      );
                                }
                              },
                        child: const Text("Reset password"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

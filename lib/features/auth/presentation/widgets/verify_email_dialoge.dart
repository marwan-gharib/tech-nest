import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:tech_nest/core/router/routers.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';

class VerifyEmailDialoge extends StatefulWidget {
  final String email;
  const VerifyEmailDialoge({required this.email, super.key});

  @override
  State<VerifyEmailDialoge> createState() => _VerifyEmailDialogeState();
}

class _VerifyEmailDialogeState extends State<VerifyEmailDialoge> {
  late final TextEditingController _controller;

  late final ValueNotifier<bool> _isErrNotifire;

  @override
  void initState() {
    _controller = TextEditingController();

    _isErrNotifire = ValueNotifier<bool>(false);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _isErrNotifire.dispose();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Text(
                    "Verify your E-mail address",
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Pinput(
                controller: _controller,
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
              const SizedBox(height: 50),
              BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                listener: (context, state) async {
                  if (state is VerifyEmailSuccess) {
                    _isErrNotifire.value = false;
                    context.go(Routers.demoPath);
                  } else if (state is VerifyEmailFailed) {
                    _isErrNotifire.value = true;
                  }
                },
                builder: (context, state) {
                  if (state is VerifyEmailLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: _controller.text.isEmpty
                        ? null
                        : () {
                            if (_controller.text.isNotEmpty &&
                                int.tryParse(_controller.text) != null &&
                                context.mounted) {
                              context.read<VerifyEmailCubit>().verifyEmail(
                                email: widget.email,
                                code: _controller.text,
                              );
                            }
                          },
                    child: const Text("Create Acount"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

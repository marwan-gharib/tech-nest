import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_partition_dialoge.dart';

class VerifyEmailDialoge extends StatefulWidget {
  final String email;
  const VerifyEmailDialoge({required this.email, super.key});

  @override
  State<VerifyEmailDialoge> createState() => _VerifyEmailDialogeState();
}

class _VerifyEmailDialogeState extends State<VerifyEmailDialoge> {
  late final TextEditingController _controller;
  late final ValueNotifier<bool> _isErrNotifier;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isErrNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _isErrNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 400),
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInExpo,
        builder: (context, value, child) =>
            Transform.scale(scale: value, child: child),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: theme.shadowColor),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPartitionDialoge(
                pinCodeController: _controller,
                isErrNotifire: _isErrNotifier,
                label: "Verify your E-mail address",
              ),
              const SizedBox(height: AppSpacing.xxl),
              BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                listener: _verifyEmailListener,
                builder: _verifyEmailBuilder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyEmailListener(
    BuildContext context,
    VerifyEmailState state,
  ) async {
    if (state is VerifyEmailSuccess) {
      _isErrNotifier.value = false;
      context.go(Routes.homeScreenPath);
    } else if (state is VerifyEmailFailed) {
      _isErrNotifier.value = true;
    } else if (state is VerifyEmailSuccess || state is VerifyEmailLoading) {
      _isErrNotifier.value = false;
    }
  }

  Widget _verifyEmailBuilder(BuildContext context, VerifyEmailState state) {
    if (state is VerifyEmailLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return ElevatedButton(
      onPressed: _controller.text.isEmpty ? null : _onButtonPressed,
      child: const Text("Create Account"),
    );
  }

  Future<void> _onButtonPressed() async {
    if (_controller.text.isNotEmpty &&
        int.tryParse(_controller.text) != null &&
        context.mounted) {
      await context.read<VerifyEmailCubit>().verifyEmail(
        email: widget.email,
        code: _controller.text,
      );
    }
  }
}

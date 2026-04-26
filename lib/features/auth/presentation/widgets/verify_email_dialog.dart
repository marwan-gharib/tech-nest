import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/widgets/custom_pin_code_dialog.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class VerifyEmailDialog extends StatefulWidget {
  final String email;

  const VerifyEmailDialog({required this.email, super.key});

  @override
  State<VerifyEmailDialog> createState() => _VerifyEmailDialogState();
}

class _VerifyEmailDialogState extends State<VerifyEmailDialog> {
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
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: context.colors.textPrimary.withValues(alpha: 0.1),
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPinCodeDialog(
                pinCodeController: _controller,
                isErrNotifire: _isErrNotifier,
                label: context.t.auth.verifyEmailTitle,
                hint: context.t.auth.enterCode,
                errorText: context.t.auth.invalidCode,
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

  void _verifyEmailListener(BuildContext context, VerifyEmailState state) {
    if (state is VerifyEmailSuccess) {
      _isErrNotifier.value = false;
      context.go(Routes.homeScreenPath);
    } else if (state is VerifyEmailFailed) {
      // no showing snack bar here
      _isErrNotifier.value = true;
    } else if (state is VerifyEmailLoading) {
      _isErrNotifier.value = false;
    }
  }

  Widget _verifyEmailBuilder(BuildContext context, VerifyEmailState state) {
    if (state is VerifyEmailLoading) {
      return SizedBox(
        height: AppSpacing.xxl + AppSpacing.lg,
        child: Center(
          child: CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: _controller.text.isEmpty ? null : _onButtonPressed,
      child: Text(context.t.auth.verifyEmail),
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


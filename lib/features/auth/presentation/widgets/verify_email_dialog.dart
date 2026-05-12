import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/auth/presentation/cubits/verify_email_cubit/verify_email_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_dialog_shell.dart';
import 'package:tech_nest/features/auth/presentation/widgets/auth_loading_indicator.dart';
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
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isErrNotifier = ValueNotifier<bool>(false);
    _authNotifier = sl<AuthNotifier>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _isErrNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthDialogShell(
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
          const SizedBox(height: AppSpacing.xl),
          BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
            listener: _verifyEmailListener,
            builder: _verifyEmailBuilder,
          ),
        ],
      ),
    );
  }

  void _verifyEmailListener(BuildContext context, VerifyEmailState state) {
    if (state is VerifyEmailSuccess) {
      _isErrNotifier.value = false;
      context.pop(true);
      _authNotifier.login();
      context.goNamed(RouteNames.home);
    } else if (state is VerifyEmailFailed) {
      _isErrNotifier.value = true;
    } else if (state is VerifyEmailLoading) {
      _isErrNotifier.value = false;
    }
  }

  Widget _verifyEmailBuilder(BuildContext context, VerifyEmailState state) {
    if (state is VerifyEmailLoading) return const AuthLoadingIndicator();
    return ElevatedButton(
      onPressed: _onButtonPressed,
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

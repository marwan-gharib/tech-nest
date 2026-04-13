import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class CustomPinCodeDialog extends StatelessWidget {
  final TextEditingController pinCodeController;
  final ValueNotifier<bool> isErrNotifire;
  final String label;
  final String hint;
  final String errorText;

  static const double _pinWidth = 35.0;
  static const double _pinHeight = 40.0;
  static const double _pinBorderRadius = 12.0;

  const CustomPinCodeDialog({
    required this.pinCodeController,
    required this.isErrNotifire,
    required this.label,
    required this.hint,
    required this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Text(label, style: theme.textTheme.labelLarge),
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Pinput(
          controller: pinCodeController,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          length: 6,
          animationCurve: Curves.linear,
          animationDuration: const Duration(milliseconds: 200),
          autofocus: true,
          defaultPinTheme: PinTheme(
            margin: const EdgeInsets.all(2),
            width: _pinWidth,
            height: _pinHeight,
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(_pinBorderRadius),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ValueListenableBuilder(
          valueListenable: isErrNotifire,
          builder: (context, value, child) {
            if (!value) return const SizedBox.shrink();
            return Text(
              errorText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
              ),
            );
          },
        ),
      ],
    );
  }
}

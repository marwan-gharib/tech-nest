import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Text(label, style: context.labelLarge),
            IconButton(
              onPressed: () => context.pop(false),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: context.bodyMedium.copyWith(fontWeight: FontWeight.bold),
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
            textStyle: context.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(_pinBorderRadius),
              border: Border.all(color: context.colors.border),
            ),
          ),
          focusedPinTheme: PinTheme(
            margin: const EdgeInsets.all(2),
            width: _pinWidth,
            height: _pinHeight,
            textStyle: context.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(_pinBorderRadius),
              border: Border.all(color: context.colorScheme.primary, width: 2),
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
              style: context.bodyMedium.copyWith(color: context.colors.error),
            );
          },
        ),
      ],
    );
  }
}

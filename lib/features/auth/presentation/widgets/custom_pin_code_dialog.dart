import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class CustomPinCodeDialog extends StatelessWidget {
  final TextEditingController pinCodeController;
  final ValueNotifier<bool> isErrNotifire;
  final String label;
  final String hint;
  final String errorText;

  static const double _pinWidth = 44.0;
  static const double _pinHeight = 52.0;
  static const double _pinBorderRadius = AppRadius.lg;

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
            _CloseButton(),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _PinInput(controller: pinCodeController),
        const SizedBox(height: AppSpacing.md),
        ValueListenableBuilder<bool>(
          valueListenable: isErrNotifire,
          builder: (context, value, child) {
            if (!value) return const SizedBox.shrink();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  size: AppSpacing.md,
                  color: context.colors.error,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    errorText,
                    style: context.bodyMedium.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.shimmerBase,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => context.pop(false),
        icon: const Icon(Icons.close),
        iconSize: 18,
      ),
    );
  }
}

class _PinInput extends StatelessWidget {
  final TextEditingController controller;

  const _PinInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.bodyLarge.copyWith(
      fontWeight: FontWeight.bold,
      color: context.colors.textPrimary,
    );
    final defaultDecor = BoxDecoration(
      color: context.colors.background,
      borderRadius: BorderRadius.circular(CustomPinCodeDialog._pinBorderRadius),
      border: Border.all(color: context.colors.border),
    );
    final focusedDecor = BoxDecoration(
      color: context.colors.background,
      borderRadius: BorderRadius.circular(CustomPinCodeDialog._pinBorderRadius),
      border: Border.all(color: context.colorScheme.primary, width: 2),
    );
    final pinSize = PinTheme(
      margin: const EdgeInsets.all(2),
      width: CustomPinCodeDialog._pinWidth,
      height: CustomPinCodeDialog._pinHeight,
      textStyle: textStyle,
    );

    return Pinput(
      controller: controller,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      length: 6,
      animationCurve: Curves.easeOut,
      animationDuration: const Duration(milliseconds: 200),
      autofocus: true,
      defaultPinTheme: pinSize.copyWith(decoration: defaultDecor),
      focusedPinTheme: pinSize.copyWith(decoration: focusedDecor),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class CustomPriceField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;

  const CustomPriceField({
    required this.controller,
    required this.label,
    this.errorText,
    super.key,
  });

  @override
  State<CustomPriceField> createState() => _CustomPriceFieldState();
}

class _CustomPriceFieldState extends State<CustomPriceField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.errorText != null;

    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: context.colors.border, width: 1.0),
    );

    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: context.colorScheme.primary, width: 1.5),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: context.colorScheme.error, width: 1.5),
    );

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: isError
          ? context.colorScheme.error
          : context.colorScheme.primary,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: context.bodyLarge.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: isError
            ? context.colorScheme.error.withValues(alpha: 0.04)
            : _isFocused
            ? context.colorScheme.primary.withValues(alpha: 0.04)
            : context.colors.surface,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: border,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.sm,
          ),
          child: Text(
            '\$',
            style: context.bodyLarge.copyWith(
              color: isError
                  ? context.colorScheme.error
                  : _isFocused
                  ? context.colorScheme.primary
                  : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: widget.label,
        hintStyle: context.bodyMedium.copyWith(
          color: context.colors.textSecondary.withValues(alpha: 0.5),
        ),
        errorText: widget.errorText,
        errorStyle: context.labelSmall.copyWith(
          color: context.colorScheme.error,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
      ),
    );
  }
}

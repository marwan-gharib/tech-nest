import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
    super.key,
    this.fieldKey,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.isObscure,
    this.onVisibilityToggle,
  });

  final TextEditingController controller;
  final Key? fieldKey;
  final String? label;
  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool? isObscure;
  final VoidCallback? onVisibilityToggle;
  final TextInputType keyboardType;
  final String? Function(String? value)? validator;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _internalIsObscure = true;

  bool get _isObscure => widget.isObscure ?? _internalIsObscure;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return TextFormField(
      key: widget.fieldKey,
      errorBuilder: _errorBuilder,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: widget.controller,
      cursorColor: colorScheme.primary,
      cursorErrorColor: context.colors.error,
      keyboardType: widget.keyboardType,
      maxLines: widget.isPassword ? 1 : null,
      obscureText: widget.isPassword ? _isObscure : false,
      style: context.bodyLarge.copyWith(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: context.bodyLarge.copyWith(
          color: context.colors.textSecondary,
        ),
        hintText: widget.hint,
        hintStyle: context.bodyMedium.copyWith(
          color: context.colors.textSecondary.withValues(alpha: 0.6),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: context.colors.textSecondary)
            : null,
        suffixIcon: widget.isPassword ? _buildVisibilityIcon() : null,
      ),
      validator: widget.validator,
    );
  }

  Widget? _buildVisibilityIcon() {
    if (widget.onVisibilityToggle != null) {
      return IconButton(
        onPressed: widget.onVisibilityToggle,
        icon: Icon(
          _isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: context.colors.textSecondary,
        ),
      );
    }
    if (widget.isObscure == null) {
      return IconButton(
        onPressed: () =>
            setState(() => _internalIsObscure = !_internalIsObscure),
        icon: Icon(
          _internalIsObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: context.colors.textSecondary,
        ),
      );
    }
    return null;
  }

  Widget _errorBuilder(BuildContext context, String errorText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.error_outline,
          size: AppSpacing.md,
          color: context.colors.error,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            errorText,
            style: context.bodyMedium.copyWith(color: context.colors.error),
          ),
        ),
      ],
    );
  }
}

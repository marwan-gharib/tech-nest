import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
    super.key,
    this.isPassword = false,
    this.validator,
  });

  final TextEditingController controller;
  final String? label;
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String? value)? validator;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      errorBuilder: _errorBuilder,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: widget.controller,
      cursorColor: colorScheme.primary,
      cursorErrorColor: colorScheme.primary,
      keyboardType: widget.keyboardType,
      maxLines: widget.isPassword ? 1 : null,
      obscureText: widget.isPassword ? _isObscure : false,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintText: widget.hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor,
        ),
        suffixIcon: widget.isPassword ? _passwordVisibility() : null,
      ),
      validator: widget.validator,
    );
  }

  IconButton _passwordVisibility() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
      icon: Icon(
        _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _errorBuilder(BuildContext context, String errorText) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.error_outline,
          size: AppSpacing.md,
          color: colorScheme.error,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            errorText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    required this.controller,
    required this.lable,
    required this.hint,
    required this.keyboardType,
    super.key,
    this.isPassword = false,
    this.validator,
  });

  final TextEditingController controller;
  final String? lable;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          errorBuilder: _errorBuilder,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: widget.controller,
          cursorColor: Theme.of(context).colorScheme.primary,
          cursorErrorColor: Theme.of(context).colorScheme.primary,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : null,
          obscureText: widget.isPassword ? _isObscure : false,
          decoration: InputDecoration(
            labelText: widget.lable,
            labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            hintText: widget.hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).hintColor,
            ),
            suffixIcon: widget.isPassword ? _passwordVisibility() : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }

  IconButton _passwordVisibility() {
    return IconButton(
      onPressed: () {
        _isObscure = !_isObscure;
        setState(() {});
      },
      icon: Icon(
        _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Row _errorBuilder(BuildContext context, String errorText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.error_outline,
          size: 16,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            errorText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

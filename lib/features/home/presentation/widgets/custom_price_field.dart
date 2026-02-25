import 'package:flutter/material.dart';

class CustomPriceField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CustomPriceField({
    required this.controller,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        cursorColor: Theme.of(context).colorScheme.primary,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: _border,
          errorBorder: _border,
          disabledBorder: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          focusedErrorBorder: _border,
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimary,
          hintText: label,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).hintColor),
          isDense: true,
        ),
      ),
    );
  }

  InputBorder get _border => OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(16),
  );
}

import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';

class CustomSearchField extends StatelessWidget {
  final ValueChanged<String?> onSubmit;
  final ValueChanged<String?>? onChange;
  final TextEditingController controller;

  const CustomSearchField({
    required this.controller,
    required this.onSubmit,
    this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: colorScheme.primary,
      cursorErrorColor: colorScheme.error,
      keyboardType: TextInputType.name,
      onSubmitted: (value) => onSubmit(value),
      onChanged: (value) => onChange?.call(value),
      decoration: InputDecoration(
        border: _border,
        errorBorder: _border,
        disabledBorder: _border,
        enabledBorder: _border,
        focusedBorder: _border,
        focusedErrorBorder: _border,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        hintText: "Search products...",
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.outline,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
        isDense: true,
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            if (value.text.isNotEmpty) {
              return IconButton(
                onPressed: () {
                  controller.clear();
                  onSubmit(null);
                },
                icon: const Icon(Icons.clear_rounded),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  InputBorder get _border => OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(AppRadius.full),
      );
}

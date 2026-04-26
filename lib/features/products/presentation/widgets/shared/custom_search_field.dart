import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class CustomSearchField extends StatelessWidget {
  final ValueChanged<String?> onSubmit;
  final ValueChanged<String?>? onChange;
  final VoidCallback? onClear;
  final String? hintText;
  final TextEditingController controller;

  const CustomSearchField({
    required this.controller,
    required this.onSubmit,
    this.onChange,
    this.onClear,
    this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: colorScheme.primary,
      cursorErrorColor: context.colors.error,
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
        fillColor: context.colorScheme.outline,
        hintText: hintText ?? context.t.home.search,
        hintStyle: context.bodyLarge.copyWith(
          color: context.colors.textSecondary,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
        isDense: true,
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            if (value.text.isNotEmpty) {
              return IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  controller.clear();
                  onClear?.call();
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

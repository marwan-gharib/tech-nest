import 'package:flutter/material.dart';

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
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorErrorColor: Theme.of(context).colorScheme.primary,
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
        fillColor: Theme.of(context).colorScheme.onPrimary,
        hintText: "Search...",
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).hintColor,
        ),
        prefixIcon: const Icon(Icons.search),
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
                icon: const Icon(Icons.clear),
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
    borderRadius: BorderRadius.circular(20),
  );
}

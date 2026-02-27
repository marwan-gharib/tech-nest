import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
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
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  String _lastEntry = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorErrorColor: Theme.of(context).colorScheme.primary,
      keyboardType: TextInputType.name,
      onSubmitted: (value) => widget.onSubmit(value),
      onChanged: (value) {
        widget.onChange?.call(value);
        if ((_lastEntry.isNotEmpty && value.isEmpty) ||
            (_lastEntry.isEmpty && value.isNotEmpty)) {
          setState(() {});
        }
        _lastEntry = value;
      },
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
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).hintColor),
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  widget.controller.clear();
                  setState(() {});
                  _lastEntry = '';
                  widget.onSubmit(null);
                },
                icon: const Icon(Icons.clear),
              )
            : null,
      ),
    );
  }

  InputBorder get _border => OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(20),
  );
}

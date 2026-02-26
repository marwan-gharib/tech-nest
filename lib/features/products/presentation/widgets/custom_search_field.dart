import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  final ValueChanged<String?> onSubmit;
  final ValueChanged<String?>? onChange;

  const CustomSearchField({required this.onSubmit, this.onChange, super.key});

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late final TextEditingController _controller;

  late final ValueNotifier<bool> _closeNotifire;

  @override
  void initState() {
    _controller = TextEditingController()
      ..addListener(_searchControllerListener);
    _closeNotifire = ValueNotifier<bool>(false);

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_searchControllerListener);
    _controller.dispose();
    _closeNotifire.dispose();
    super.dispose();
  }

  void _searchControllerListener() =>
      _closeNotifire.value = _controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        cursorColor: Theme.of(context).colorScheme.primary,
        cursorErrorColor: Theme.of(context).colorScheme.primary,
        keyboardType: TextInputType.name,
        onSubmitted: (value) => widget.onSubmit(value),
        onChanged: (value) => widget.onChange?.call(value),
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
          suffixIcon: ValueListenableBuilder(
            valueListenable: _closeNotifire,
            builder: (context, value, child) {
              return value
                  ? IconButton(
                      onPressed: () {
                        _controller.clear();
                        widget.onSubmit(null);
                      },
                      icon: child!,
                    )
                  : const SizedBox.shrink();
            },
            child: const Icon(Icons.close),
          ),
        ),
      ),
    );
  }

  InputBorder get _border => OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(20),
  );
}

import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  const CustomSearchField({super.key});

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8, top: 20),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: _controller,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          cursorColor: Theme.of(context).colorScheme.primary,
          cursorErrorColor: Theme.of(context).colorScheme.primary,
          keyboardType: TextInputType.name,
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
                        onPressed: () => _controller.clear(),
                        icon: child!,
                      )
                    : const SizedBox.shrink();
              },
              child: const Icon(Icons.close),
            ),
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

import 'package:flutter/material.dart';

class SearchSliverAppBar extends StatefulWidget {
  const SearchSliverAppBar({super.key});

  @override
  State<SearchSliverAppBar> createState() => _SearchSliverAppBarState();
}

class _SearchSliverAppBarState extends State<SearchSliverAppBar> {
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

  void _searchControllerListener() {
    _closeNotifire.value = _controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      expandedHeight: 90,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8, top: 20),
        child: TextField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: _controller,
          cursorColor: Theme.of(context).colorScheme.primary,
          cursorErrorColor: Theme.of(context).colorScheme.primary,
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).hintColor),
            prefixIcon: const Icon(Icons.search),
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
}

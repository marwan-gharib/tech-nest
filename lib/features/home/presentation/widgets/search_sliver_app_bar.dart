import 'package:flutter/material.dart';

class SearchSliverAppBar extends StatefulWidget {
  const SearchSliverAppBar({super.key});

  @override
  State<SearchSliverAppBar> createState() => _SearchSliverAppBarState();
}

class _SearchSliverAppBarState extends State<SearchSliverAppBar> {
  late final TextEditingController _controller;

  bool _isSearching = false;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching
              ? IconButton(
                  key: const ValueKey("close"),
                  onPressed: () => setState(() => _isSearching = false),
                  icon: const Icon(Icons.close),
                )
              : IconButton(
                  key: const ValueKey("search"),
                  onPressed: () => setState(() => _isSearching = true),
                  icon: const Icon(Icons.search),
                ),
        ),
      ],
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
        child: _isSearching ? const TextField() : const SizedBox.shrink(),
      ),
    );
  }
}

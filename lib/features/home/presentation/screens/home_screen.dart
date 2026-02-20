import 'package:flutter/material.dart';
import 'package:tech_nest/features/products/presentation/widgets/products_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CustomScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // SearchSliverAppBar(),
              SliverPersistentHeader(
                floating: true,
                delegate: SearchHeaderDelegate(
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 2,
                      left: 8,
                      right: 8,
                      top: 20,
                    ),
                    child: TextField(
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      // controller: _controller,
                      cursorColor: Theme.of(context).colorScheme.primary,
                      cursorErrorColor: Theme.of(context).colorScheme.primary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        hintText: "Search...",
                        hintStyle: Theme.of(context).textTheme.bodyLarge!
                            .copyWith(color: Theme.of(context).hintColor),
                        prefixIcon: const Icon(Icons.search),
                        // suffixIcon: ValueListenableBuilder(
                        //   valueListenable: _closeNotifire,
                        //   builder: (context, value, child) {
                        //     return value
                        //         ? IconButton(
                        //             onPressed: () => _controller.clear(),
                        //             icon: child!,
                        //           )
                        //         : const SizedBox.shrink();
                        //   },
                        //   child: const Icon(Icons.close),
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
              const ProductsGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SearchHeaderDelegate(this.child);

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 110;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

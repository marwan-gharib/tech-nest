import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/features/categories/presentation/cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/categories_view.dart';
import 'package:tech_nest/features/home/presentation/widgets/custom_search_field.dart';
import 'package:tech_nest/features/home/presentation/widgets/search_header_delegate.dart';
import 'package:tech_nest/features/products/presentation/widgets/products_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  double? _lastOffset;

  late final FocusNode _focusNode;

  @override
  void initState() {
    _scrollController = ScrollController();

    _focusNode = FocusNode()..addListener(_focusNodeListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.removeListener(_focusNodeListener);
    _focusNode.dispose();
    super.dispose();
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus && _lastOffset != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.jumpTo(_lastOffset!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              _lastOffset = notification.metrics.pixels;
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  floating: true,
                  pinned: true,
                  delegate: SearchHeaderDelegate(
                    Column(
                      children: [
                        const CustomSearchField(),
                        BlocProvider(
                          create: (context) =>
                              sl<FetchCategoriesCubit>()..fetchCategories(),
                          child: CategoriesView(onCategorySelected: (value) {}),
                        ),
                      ],
                    ),
                  ),
                ),
                const ProductsGrid(),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

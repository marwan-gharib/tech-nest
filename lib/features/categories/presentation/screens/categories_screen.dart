import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/core/shared/presentation/cubits/locale/locale_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/left_category_sidebar.dart';
import 'package:tech_nest/features/categories/presentation/widgets/right_product_list.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late final ScrollController _scrollController;
  late final ValueNotifier<int> _selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _selectedCategoryIndex = ValueNotifier<int>(0);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CategoryProductsCubit>().fetchMoreCategoryProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= maxScroll * 0.8;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _selectedCategoryIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocaleCubit, LocaleState>(
      listenWhen: (previous, current) => previous.locale != current.locale,
      listener: (context, state) {
        context.read<FetchCategoriesCubit>().fetchCategories();
      },
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: LeftCategorySidebar(
                selectedCategoryIndex: _selectedCategoryIndex,
                onCategorySelected: (index, categoryId) {
                  _scrollController.jumpTo(0);
                  context
                      .read<CategoryProductsCubit>()
                      .fetchInitialCategoryProducts(categoryId: categoryId);
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: RightProductList(scrollController: _scrollController),
            ),
          ],
        ),
      ),
    );
  }
}

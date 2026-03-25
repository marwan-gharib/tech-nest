import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/widgets/product_card.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/category_card.dart';

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
    _scrollController = ScrollController()..addListener(_onScroll);

    _selectedCategoryIndex = ValueNotifier<int>(0);

    super.initState();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CategoryProductsCubit>().fetchMoreCategoryProducts();
    }
  }

  bool get _isBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= maxScroll * 0.8;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _selectedCategoryIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              child: BlocConsumer<FetchCategoriesCubit, FetchCategoriesState>(
                listener: _categoriesListener,
                builder: _categoriesBuilder,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: BlocConsumer<CategoryProductsCubit, CategoryProductsState>(
              listener: _productsListener,
              builder: _productsBuilder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoriesBuilder(BuildContext context, FetchCategoriesState state) {
    if (state is FetchCategoriesLoaded) {
      final categories = state.categories;
      return ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        itemBuilder: (context, index) {
          return ValueListenableBuilder<int>(
            valueListenable: _selectedCategoryIndex,
            builder: (context, value, child) {
              final category = categories[index];
              return CategoryCard(
                isSelected: value == index,
                category: category,
                onTap: () {
                  if (value == index) return;
                  _selectedCategoryIndex.value = index;
                  context
                      .read<CategoryProductsCubit>()
                      .fetchInitialCategoryProducts(
                        categoryId: categories[index].id,
                      )
                      .then((_) => _scrollController.jumpTo(0));
                },
              );
            },
          );
        },
      );
    }
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            height: 40,
            width: double.infinity,
            color: Theme.of(context).colorScheme.outline,
          ),
        );
      },
    );
  }

  void _categoriesListener(BuildContext context, FetchCategoriesState state) {
    if (state is FetchCategoriesLoaded && state.categories.isNotEmpty) {
      final selectedIndex = _selectedCategoryIndex.value;
      if (selectedIndex < state.categories.length) {
        final categoryId = state.categories[selectedIndex].id;
        context.read<CategoryProductsCubit>().fetchInitialCategoryProducts(
          categoryId: categoryId,
        );
      }
    }
    if (state is FetchCategoriesFailed) {
      customSnackBar(context, message: state.message);
    }
  }

  Widget _productsBuilder(BuildContext context, CategoryProductsState state) {
    if (state.products != null) {
      final products = state.products;

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: products!.length + 1,
        itemBuilder: (context, index) {
          if (index == products.length && state.isLoadingMore) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          } else if (index == products.length && !state.isLoadingMore) {
            return const SizedBox.shrink();
          }
          final product = products[index];
          return ProductCard(product: product);
        },
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Skeletonizer(child: ProductCard(product: Product.empty()));
      },
    );
  }

  void _productsListener(BuildContext context, CategoryProductsState state) {
    if (state.errMessage != null) {
      customSnackBar(context, message: state.errMessage!);
    }
  }
}

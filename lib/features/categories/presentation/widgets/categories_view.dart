import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/categories/presentation/cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/category_label_widget.dart';

class CategoriesView extends StatefulWidget {
  final int? initialCategoryId;
  final ValueChanged<int?> onCategorySelected;
  const CategoriesView({
    required this.onCategorySelected,
    this.initialCategoryId,
    super.key,
  });

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late final ValueNotifier<int?> _selectedCategoryNotifire;

  @override
  void initState() {
    _selectedCategoryNotifire = ValueNotifier<int?>(widget.initialCategoryId);
    super.initState();
  }

  @override
  void dispose() {
    _selectedCategoryNotifire.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: BlocConsumer<FetchCategoriesCubit, FetchCategoriesState>(
        listener: (context, state) {
          if (state is FetchCategoriesFailed) {
            customSnackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is FetchCategoriesLoading) {
            return ListView.builder(
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const Skeletonizer(
                  child: SizedBox(height: 24, width: 80),
                );
              },
            );
          } else if (state is FetchCategoriesLoaded) {
            final categories = state.categories;

            return ListView.builder(
              itemCount: categories.length + 1,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) {
                return ValueListenableBuilder<int?>(
                  valueListenable: _selectedCategoryNotifire,
                  builder: (_, selectedCategory, _) {
                    if (index == 0) {
                      return CategoryLabelWidget<String>(
                        category: "All",
                        isSelected: selectedCategory == null,
                        onTap: (id) {
                          _selectedCategoryNotifire.value = id;
                          widget.onCategorySelected(id);
                        },
                      );
                    }

                    final category = categories[index - 1];
                    return CategoryLabelWidget<CategoryEntity>(
                      category: category,
                      isSelected: selectedCategory == category.id,
                      onTap: (id) {
                        _selectedCategoryNotifire.value = id;
                        widget.onCategorySelected(id);
                      },
                    );
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

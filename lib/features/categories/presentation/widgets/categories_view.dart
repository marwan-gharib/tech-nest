import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/categories/presentation/cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/category_label_widget.dart';

class CategoriesView extends StatefulWidget {
  final ValueChanged<int> onCategorySelected;
  const CategoriesView({required this.onCategorySelected, super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
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
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];

                return CategoryLabelWidget(
                  category: category,
                  isSelected: selectedId == category.id,
                  onTap: (id) {
                    selectedId = id;
                    widget.onCategorySelected(id);
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

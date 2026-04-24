import 'package:flutter/material.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/shared/domain/entities/category_entity.dart';
import 'package:tech_nest/core/shared/presentation/widgets/category_label_widget.dart';
import 'package:tech_nest/core/shared/presentation/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

class CategoriesView extends StatefulWidget {
  final int? initialCategoryId;
  final ValueChanged<int?> onCategorySelected;
  final List<CategoryEntity> categories;
  final bool isLoading;
  final Failure? error;
  final VoidCallback onRetry;

  const CategoriesView({
    required this.onCategorySelected,
    required this.categories,
    required this.isLoading,
    required this.onRetry,
    this.initialCategoryId,
    this.error,
    super.key,
  });

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late final ValueNotifier<int?> _selectedCategoryNotifier;

  @override
  void initState() {
    _selectedCategoryNotifier = ValueNotifier<int?>(widget.initialCategoryId);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CategoriesView oldWidget) {
    if (oldWidget.initialCategoryId != widget.initialCategoryId) {
      _selectedCategoryNotifier.value = widget.initialCategoryId;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _selectedCategoryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: RemoteDataFailureView(
          failure: widget.error!,
          compact: true,
          onRetry: widget.onRetry,
        ),
      );
    }

    return SizedBox(
      height: AppSpacing.homeCategoryRowHeight,
      child: widget.isLoading 
          ? ListView.builder(
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const Skeletonizer(
                  child: SizedBox(height: 24, width: 80),
                );
              },
            )
          : ListView.builder(
              itemCount: widget.categories.length + 1,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemBuilder: (context, index) {
                return ValueListenableBuilder<int?>(
                  valueListenable: _selectedCategoryNotifier,
                  builder: (_, selectedCategory, _) {
                    if (index == 0) {
                      return CategoryLabelWidget<String>(
                        category: context.t.common.all,
                        isSelected: selectedCategory == null,
                        onTap: (id) {
                          _selectedCategoryNotifier.value = id;
                          widget.onCategorySelected(id);
                        },
                      );
                    }

                    final category = widget.categories[index - 1];
                    return CategoryLabelWidget<CategoryEntity>(
                      category: category,
                      isSelected: selectedCategory == category.id,
                      onTap: (id) {
                        _selectedCategoryNotifier.value = id;
                        widget.onCategorySelected(id);
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

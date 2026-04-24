import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/presentation/models/filter_data.dart';
import 'package:tech_nest/service_locator.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/core/shared/domain/enums/order_type.dart';
import 'package:tech_nest/core/shared/domain/enums/sort_type.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/home/presentation/notifiers/filter_components_notifier.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_apply_button.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_category_section.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_header.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_price_range_fields.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_section_header.dart';
import 'package:tech_nest/features/home/presentation/widgets/radio_buttons_group.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class FilterComponents extends StatefulWidget {
  final FilterData filterData;
  final ValueChanged<FilterData> onApply;

  const FilterComponents({
    required this.filterData,
    required this.onApply,
    super.key,
  });

  @override
  State<FilterComponents> createState() => _FilterComponentsState();
}

class _FilterComponentsState extends State<FilterComponents> {
  late final FilterComponentsNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = FilterComponentsNotifier(widget.filterData);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FilterComponents oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterData != widget.filterData) {
      _notifier.updateFrom(widget.filterData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.sheet,
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListenableBuilder(
                    listenable: _notifier,
                    builder: (context, _) => FilterHeader(
                      activeFilterCount: _notifier.activeFilterCount,
                      onReset: _notifier.reset,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: AppSpacing.xs),
                  BlocProvider(
                    create: (context) =>
                        sl<FetchCategoriesCubit>()..fetchCategories(),
                    child: ListenableBuilder(
                      listenable: _notifier,
                      builder: (context, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FilterSectionHeader(
                              label: context.t.home.categories,
                            ),
                            FilterCategorySection(
                              initialCategoryId: _notifier.categoryId,
                              onSelected: (value) =>
                                  _notifier.categoryId = value,
                            ),
                            FilterSectionHeader(
                              label: context.t.home.priceRange,
                            ),
                            FilterPriceRangeFields(
                              minPrice: _notifier.minPrice,
                              maxPrice: _notifier.maxPrice,
                              minPriceError: _notifier.minPriceError,
                              maxPriceError: _notifier.maxPriceError,
                            ),
                            FilterSectionHeader(label: context.t.home.sortBy),
                            RadioButtonsGroup<SortType>(
                              initialValue: _notifier.sortType,
                              values: const [SortType.name, SortType.price],
                              onTap: (value) => _notifier.sortType = value,
                              labelBuilder: (value) => value == SortType.name
                                  ? context.t.home.sortTypes.name
                                  : context.t.home.sortTypes.price,
                            ),
                            FilterSectionHeader(label: context.t.home.orderBy),
                            RadioButtonsGroup<OrderType>(
                              initialValue: _notifier.orderType,
                              values: const [OrderType.asc, OrderType.desc],
                              onTap: (value) => _notifier.orderType = value,
                              labelBuilder: (value) => value == OrderType.asc
                                  ? context.t.home.orderTypes.asc
                                  : context.t.home.orderTypes.desc,
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        );
                      },
                    ),
                  ),
                  ListenableBuilder(
                    listenable: _notifier,
                    builder: (context, _) => FilterApplyButton(
                      activeCount: _notifier.activeFilterCount,
                      enabled: _notifier.isValid,
                      onPressed: () {
                        widget.onApply(
                          FilterData(
                            categoryId: _notifier.categoryId,
                            minPrice: int.tryParse(_notifier.minPrice.text),
                            maxPrice: int.tryParse(_notifier.maxPrice.text),
                            orderType: _notifier.orderType,
                            sortType: _notifier.sortType,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

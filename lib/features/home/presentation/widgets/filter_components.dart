import 'package:flutter/material.dart';
import 'package:tech_nest/core/shared/domain/enums/order_type.dart';
import 'package:tech_nest/core/shared/domain/enums/sort_type.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_category_section.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_price_range_fields.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_section_header.dart';
import 'package:tech_nest/features/home/presentation/widgets/radio_buttons_group.dart';

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
  int? _categoryId;
  SortType? _sortType;
  OrderType? _orderType;

  late final TextEditingController _minPrice;
  late final TextEditingController _maxPrice;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.filterData.categoryId;
    _sortType = widget.filterData.sortType;
    _orderType = widget.filterData.orderType;

    _minPrice = TextEditingController(
      text: widget.filterData.minPrice?.toString(),
    );
    _maxPrice = TextEditingController(
      text: widget.filterData.maxPrice?.toString(),
    );
  }

  @override
  void dispose() {
    _minPrice.dispose();
    _maxPrice.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FilterComponents oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterData != widget.filterData) {
      setState(() {
        _categoryId = widget.filterData.categoryId;
        _sortType = widget.filterData.sortType;
        _orderType = widget.filterData.orderType;
        _minPrice.text = widget.filterData.minPrice?.toString() ?? '';
        _maxPrice.text = widget.filterData.maxPrice?.toString() ?? '';
      });
    }
  }

  int get _activeFilterCount {
    int count = 0;
    if (_categoryId != null) count++;
    if (_sortType != null) count++;
    if (_orderType != null) count++;
    if (_minPrice.text.isNotEmpty) count++;
    if (_maxPrice.text.isNotEmpty) count++;
    return count;
  }

  void _onResetPressed() {
    setState(() {
      _categoryId = null;
      _sortType = null;
      _orderType = null;
      _minPrice.clear();
      _maxPrice.clear();
    });
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterHandle(theme: theme),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FilterHeader(
                    activeFilterCount: _activeFilterCount,
                    onReset: _onResetPressed,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: AppSpacing.xs),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FilterSectionHeader(label: 'Categories'),
                        FilterCategorySection(
                          initialCategoryId: _categoryId,
                          onSelected: (value) =>
                              setState(() => _categoryId = value),
                        ),
                        const FilterSectionHeader(label: 'Price Range'),
                        FilterPriceRangeFields(
                          minPrice: _minPrice,
                          maxPrice: _maxPrice,
                        ),
                        const FilterSectionHeader(label: 'Sort by'),
                        RadioButtonsGroup<SortType>(
                          key: ValueKey(_sortType),
                          initialValue: _sortType,
                          values: const [SortType.name, SortType.price],
                          onTap: (value) => setState(() => _sortType = value),
                          labelBuilder: (value) => value.name.capitalizeFirst(),
                        ),
                        const FilterSectionHeader(label: 'Order by'),
                        RadioButtonsGroup<OrderType>(
                          key: ValueKey(_orderType),
                          initialValue: _orderType,
                          values: const [OrderType.asc, OrderType.desc],
                          onTap: (value) => setState(() => _orderType = value),
                          labelBuilder: (value) => value.name.capitalizeFirst(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                  _FilterApplyButton(
                    activeCount: _activeFilterCount,
                    onPressed: () {
                      widget.onApply(
                        FilterData(
                          categoryId: _categoryId,
                          minPrice: int.tryParse(_minPrice.text),
                          maxPrice: int.tryParse(_maxPrice.text),
                          orderType: _orderType,
                          sortType: _sortType,
                        ),
                      );
                    },
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

// ─── Private sub-widgets ─────────────────────────────────────────────────────

class _FilterHandle extends StatelessWidget {
  final ThemeData theme;

  const _FilterHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Center(
        child: Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback onReset;

  const _FilterHeader({required this.activeFilterCount, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            'Filters',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          if (activeFilterCount > 0) ...[
            const SizedBox(width: AppSpacing.sm),
            _ActiveFilterBadge(count: activeFilterCount),
          ],
          const Spacer(),
          AnimatedOpacity(
            opacity: activeFilterCount > 0 ? 1.0 : 0.35,
            duration: const Duration(milliseconds: 250),
            child: TextButton.icon(
              onPressed: activeFilterCount > 0 ? onReset : null,
              icon: Icon(
                Icons.close_rounded,
                size: 15,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                'Clear all',
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveFilterBadge extends StatelessWidget {
  final int count;

  const _ActiveFilterBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Container(
        key: ValueKey(count),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          '$count',
          style: AppTextStyles.labelSmall.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _FilterApplyButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onPressed;

  const _FilterApplyButton({
    required this.activeCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_rounded, size: 20),
              const SizedBox(width: AppSpacing.sm),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  key: ValueKey(activeCount),
                  activeCount > 0
                      ? 'Apply $activeCount Filter${activeCount == 1 ? '' : 's'}'
                      : 'Apply Filters',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

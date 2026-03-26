import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/domain/enums/order_type.dart';
import 'package:tech_nest/core/domain/enums/sort_type.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
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

  void _onResetPressed() {
    if (widget.filterData != const FilterData()) {
      widget.onApply(const FilterData());
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSpacing.sm,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: _onResetPressed,
                  icon: const Icon(Icons.settings_backup_restore_sharp),
                ),
              ),
              FilterCategorySection(
                initialCategoryId: _categoryId,
                onSelected: (value) => _categoryId = value,
              ),
              const FilterSectionHeader(label: "Price Range"),
              FilterPriceRangeFields(minPrice: _minPrice, maxPrice: _maxPrice),
              const FilterSectionHeader(label: "Sort by"),
              RadioButtonsGroup<SortType>(
                key: ValueKey(_sortType),
                initialValue: _sortType,
                values: const [SortType.name, SortType.price],
                onTap: (value) => _sortType = value,
                labelBuilder: (value) => value.name,
              ),
              const FilterSectionHeader(label: "Order by"),
              RadioButtonsGroup<OrderType>(
                key: ValueKey(_orderType),
                initialValue: _orderType,
                values: const [OrderType.asc, OrderType.desc],
                onTap: (value) => _orderType = value,
                labelBuilder: (value) => value.name,
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
                  child: const Text("Apply Filters"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

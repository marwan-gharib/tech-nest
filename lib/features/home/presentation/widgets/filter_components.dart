import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/enums/order_type.dart';
import 'package:tech_nest/core/enums/sort_type.dart';
import 'package:tech_nest/features/categories/presentation/cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/categories_view.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
import 'package:tech_nest/features/home/presentation/widgets/custom_price_field.dart';
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
    _categoryId = widget.filterData.categoryId;
    _sortType = widget.filterData.sortType;
    _orderType = widget.filterData.orderType;

    _minPrice = TextEditingController(
      text: widget.filterData.minPrice?.toString(),
    );
    _maxPrice = TextEditingController(
      text: widget.filterData.maxPrice?.toString(),
    );

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topRight,
                child: IconButton(
                  onPressed: _onResetPressed,
                  icon: const Icon(Icons.settings_backup_restore_sharp),
                ),
              ),
              _categories,
              _dialogeSeparator("Price Range"),
              _priceRangeWidget,
              _dialogeSeparator("Sort by"),
              RadioButtonsGroup<SortType>(
                key: ValueKey(_sortType),
                initialValue: _sortType,
                values: const [SortType.name, SortType.price],
                onTap: (value) => _sortType = value,
                labelBuilder: (value) => value.name,
              ),
              _dialogeSeparator("Order by"),
              RadioButtonsGroup<OrderType>(
                key: ValueKey(_orderType),
                initialValue: _orderType,
                values: const [OrderType.asc, OrderType.desc],
                onTap: (value) => _orderType = value,
                labelBuilder: (value) => value.name,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
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
                child: const Text("Apply"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _dialogeSeparator(String label) {
    return Row(children: [_divider(isFirst: true), Text(label), _divider()]);
  }

  Expanded _divider({bool isFirst = false}) {
    final double indent = 6;
    return Expanded(
      child: Divider(
        height: 40,
        endIndent: isFirst ? indent : 0,
        color: Theme.of(context).colorScheme.primary,
        thickness: 1.5,
        radius: BorderRadius.circular(10),
        indent: isFirst ? 0 : indent,
      ),
    );
  }

  BlocProvider<FetchCategoriesCubit> get _categories => BlocProvider(
    create: (context) => sl<FetchCategoriesCubit>()..fetchCategories(),
    child: CategoriesView(
      key: ValueKey(_categoryId),
      initialCategoryId: _categoryId,
      onCategorySelected: (value) => _categoryId = value,
    ),
  );

  void _onResetPressed() {
    if (widget.filterData != const FilterData()) {
      widget.onApply(const FilterData());
    } else {
      context.pop();
    }
  }

  Padding get _priceRangeWidget => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
    child: Row(
      children: [
        CustomPriceField(controller: _minPrice, label: "min price"),
        const SizedBox(width: 30),
        CustomPriceField(controller: _maxPrice, label: "max price"),
      ],
    ),
  );
}

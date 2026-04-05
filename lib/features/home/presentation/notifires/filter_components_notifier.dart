import 'package:flutter/material.dart';
import 'package:tech_nest/core/shared/domain/enums/order_type.dart';
import 'package:tech_nest/core/shared/domain/enums/sort_type.dart';
import 'package:tech_nest/core/shared/presentation/models/filter_data.dart';

class FilterComponentsNotifier extends ChangeNotifier {
  FilterComponentsNotifier(FilterData initialData) {
    _categoryId = initialData.categoryId;
    _sortType = initialData.sortType;
    _orderType = initialData.orderType;

    minPrice = TextEditingController(text: initialData.minPrice?.toString());
    maxPrice = TextEditingController(text: initialData.maxPrice?.toString());

    minPrice.addListener(notifyListeners);
    maxPrice.addListener(notifyListeners);
  }

  int? _categoryId;
  int? get categoryId => _categoryId;
  set categoryId(int? value) {
    if (_categoryId != value) {
      _categoryId = value;
      notifyListeners();
    }
  }

  SortType? _sortType;
  SortType? get sortType => _sortType;
  set sortType(SortType? value) {
    if (_sortType != value) {
      _sortType = value;
      notifyListeners();
    }
  }

  OrderType? _orderType;
  OrderType? get orderType => _orderType;
  set orderType(OrderType? value) {
    if (_orderType != value) {
      _orderType = value;
      notifyListeners();
    }
  }

  late final TextEditingController minPrice;
  late final TextEditingController maxPrice;

  int get activeFilterCount {
    int count = 0;
    if (_categoryId != null) count++;
    if (_sortType != null) count++;
    if (_orderType != null) count++;
    if (minPrice.text.isNotEmpty) count++;
    if (maxPrice.text.isNotEmpty) count++;
    return count;
  }

  String? get minPriceError => null;

  String? get maxPriceError {
    final min = int.tryParse(minPrice.text);
    final max = int.tryParse(maxPrice.text);

    if (min != null && max != null && max < min) {
      return 'Max price must be greater than Min';
    }
    return null;
  }

  bool get isValid => maxPriceError == null;

  void reset() {
    _categoryId = null;
    _sortType = null;
    _orderType = null;
    minPrice.clear();
    maxPrice.clear();
    notifyListeners();
  }

  void updateFrom(FilterData data) {
    _categoryId = data.categoryId;
    _sortType = data.sortType;
    _orderType = data.orderType;
    minPrice.text = data.minPrice?.toString() ?? '';
    maxPrice.text = data.maxPrice?.toString() ?? '';
    notifyListeners();
  }

  @override
  void dispose() {
    minPrice.removeListener(notifyListeners);
    maxPrice.removeListener(notifyListeners);
    minPrice.dispose();
    maxPrice.dispose();
    super.dispose();
  }
}

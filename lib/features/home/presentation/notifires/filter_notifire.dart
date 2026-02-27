import 'package:flutter/material.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';

class FilterNotifire extends ChangeNotifier {
  String? _search;
  FilterData _filterData = const FilterData();

  String? get searchQuery => _search;
  FilterData get filterData => _filterData;

  void search(String searchQuery) {
    _search = searchQuery;
    notifyListeners();
  }

  void filter(FilterData filters) {
    _filterData = filters;
    notifyListeners();
  }
}

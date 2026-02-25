import 'package:equatable/equatable.dart';
import 'package:tech_nest/core/enums/order_type.dart';
import 'package:tech_nest/core/enums/sort_type.dart';

class FilterData extends Equatable {
  final int? categoryId;
  final SortType? sortType;
  final OrderType? orderType;
  final int? minPrice;
  final int? maxPrice;

  const FilterData({
    this.categoryId,
    this.sortType,
    this.orderType,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [
    categoryId,
    sortType,
    orderType,
    minPrice,
    maxPrice,
  ];
}

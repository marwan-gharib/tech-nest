import 'package:equatable/equatable.dart';
import 'package:tech_nest/core/domain/enums/order_type.dart';
import 'package:tech_nest/core/domain/enums/sort_type.dart';
import 'package:tech_nest/core/domain/params/products_params.dart';

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

  ProductsParams toParams() {
    return ProductsParams(
      categoryId: categoryId,
      sortType: sortType,
      orderType: orderType,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }

  @override
  List<Object?> get props => [
    categoryId,
    sortType,
    orderType,
    minPrice,
    maxPrice,
  ];
}

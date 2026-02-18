import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/products/domain/enums/order_type.dart';
import 'package:tech_nest/features/products/domain/enums/sort_type.dart';

class ProductsParams {
  final int? categoryId;
  final String? search;
  final int? limit;
  final int? page;
  final int? minPrice;
  final int? maxPrice;
  final SortType? sortType;
  final OrderType? orderType;

  ProductsParams({
    this.categoryId,
    this.search,
    this.limit,
    this.page,
    this.minPrice,
    this.maxPrice,
    this.sortType,
    this.orderType,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.categoryID: categoryId,
      ApiKeys.search: search,
      ApiKeys.limit: limit,
      ApiKeys.page: page,
      ApiKeys.minPrice: minPrice,
      ApiKeys.maxPrice: maxPrice,
      ApiKeys.sort: sortType?.name,
      ApiKeys.order: orderType?.name,
    };
  }
}

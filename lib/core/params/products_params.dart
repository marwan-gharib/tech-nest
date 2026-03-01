import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/enums/order_type.dart';
import 'package:tech_nest/core/enums/sort_type.dart';

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

  ProductsParams copyWith({
    int? categoryId,
    String? search,
    int? limit,
    int? page,
    int? minPrice,
    int? maxPrice,
    SortType? sortType,
    OrderType? orderType,
  }) {
    return ProductsParams(
      categoryId: categoryId ?? this.categoryId,
      search: search ?? this.search,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortType: sortType ?? this.sortType,
      orderType: orderType ?? this.orderType,
    );
  }

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

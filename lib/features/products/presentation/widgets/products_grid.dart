import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/enums/order_type.dart';
import 'package:tech_nest/core/enums/sort_type.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/use_cases/get_products_usecase.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_card.dart';
import 'package:tech_nest/features/products/presentation/widgets/skelton_card.dart';

class ProductsGrid extends StatefulWidget {
  final String? searchLabel;
  final int? categoryId;
  final int? minPrice;
  final int? maxPrice;
  final SortType? sortType;
  final OrderType? orderType;

  const ProductsGrid({
    this.searchLabel,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.sortType,
    this.orderType,
    super.key,
  });

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late final GetProductsUsecase _getProductsUsecase;
  late final PagingController<int, ProductEntity> _pagingController;

  @override
  void initState() {
    _getProductsUsecase = sl<GetProductsUsecase>();

    _pagingController = PagingController<int, ProductEntity>(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: _fetchPage,
    );

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<ProductEntity>> _fetchPage(int pageKey) async {
    final ProductsParams params = ProductsParams(
      limit: 20,
      page: pageKey,
      categoryId: widget.categoryId,
      search: widget.searchLabel,
      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,
      sortType: widget.sortType,
      orderType: widget.orderType,
    );
    final res = await _getProductsUsecase.call(params: params);

    return res.fold(
      (failure) => throw PagingException(failure.message),
      (products) => products,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverGrid(
          gridDelegate: _sliverGridDelegateWithFixedCrossAxisCount(),
          state: state,
          fetchNextPage: fetchNextPage,

          // showNewPageProgressIndicatorAsGridChild: true,
          builderDelegate: PagedChildBuilderDelegate<ProductEntity>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 800),

            itemBuilder: (context, product, i) => ProductCard(product: product),

            firstPageProgressIndicatorBuilder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  gridDelegate: _sliverGridDelegateWithFixedCrossAxisCount(),
                  itemBuilder: (_, _) =>
                      const Skeletonizer(child: SkeltonCard()),
                ),
              );
            },
          ),
        );
      },
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount
  _sliverGridDelegateWithFixedCrossAxisCount() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.9,
      crossAxisSpacing: 15,
      mainAxisSpacing: 8,
    );
  }
}

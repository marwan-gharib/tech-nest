import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/presentation/cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_card.dart';
import 'package:tech_nest/features/products/presentation/widgets/skelton_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final PagingController<int, ProductEntity> _pagingController;

  late final ScrollController _scrollController;

  late final ValueNotifier<bool> _moveUpNotifire;

  @override
  void initState() {
    _pagingController = PagingController<int, ProductEntity>(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) async =>
          await context.read<FetchProductsCubit>().fetchProducts(page: pageKey),
    );

    _scrollController = ScrollController()..addListener(_scrollListener);

    _moveUpNotifire = ValueNotifier<bool>(false);

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _moveUpNotifire.dispose();
    super.dispose();
  }

  void _scrollListener() {
    _scrollController.position.pixels > 300
        ? _moveUpNotifire.value = true
        : _moveUpNotifire.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Products")),
        body: Stack(
          children: [
            PagingListener(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) {
                return PagedGridView(
                  scrollController: _scrollController,
                  padding: const EdgeInsets.only(
                    bottom: 80,
                    left: 6,
                    right: 6,
                    top: 12,
                  ),
                  gridDelegate: _sliverGridDelegateWithFixedCrossAxisCount(),
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate<ProductEntity>(
                    animateTransitions: true,
                    transitionDuration: const Duration(milliseconds: 800),

                    itemBuilder: (context, product, i) =>
                        ProductCard(product: product),

                    firstPageProgressIndicatorBuilder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          padding: const EdgeInsets.only(
                            bottom: 80,
                            left: 6,
                            right: 6,
                            top: 12,
                          ),
                          gridDelegate:
                              _sliverGridDelegateWithFixedCrossAxisCount(),
                          itemBuilder: (context, index) =>
                              const Skeletonizer(child: SkeltonCard()),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _moveUpNotifire,
              builder: (_, value, child) {
                return value ? child! : const SizedBox.shrink();
              },
              child: Positioned(
                bottom: 50,
                right: 10,
                child: InkWell(
                  onTap: () => _scrollController.jumpTo(0),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Icon(
                      Icons.keyboard_double_arrow_up_rounded,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

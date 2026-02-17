import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/presentation/cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final PagingController<int, ProductEntity> _pagingController;

  @override
  void initState() {
    _pagingController = PagingController<int, ProductEntity>(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) async {
        return await context.read<FetchProductsCubit>().fetchProducts(
          page: pageKey,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Products")),
        // body: GridView.count(
        //   crossAxisCount: 2,
        //   physics: const BouncingScrollPhysics(),
        //   addAutomaticKeepAlives: true,
        //   mainAxisSpacing: 10,
        //   children: const [
        //     ProductCard(),
        //     ProductCard(),
        //     ProductCard(),
        //     ProductCard(),
        //     ProductCard(),
        //   ],
        // ),
        body: PagingListener(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) {
            return PagedListView(
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  return const ProductCard();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

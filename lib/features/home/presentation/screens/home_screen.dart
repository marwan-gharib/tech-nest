import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/params/products_params.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
import 'package:tech_nest/features/home/presentation/notifires/filter_notifire.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_components.dart';
import 'package:tech_nest/features/home/presentation/widgets/search_header_delegate.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/products_grid.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FilterNotifire _filterNotifire;
  late final ScrollController _scrollController;

  ProductsParams _productsParams = ProductsParams(limit: 10, page: 1);

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_listener);
    _filterNotifire = FilterNotifire();

    _productsParams = _filterNotifire.filterData.toParams().copyWith(
      search: _filterNotifire.searchQuery,
      page: 1,
      limit: 10,
    );

    context.read<FetchProductsCubit>().initialFetching(params: _productsParams);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listener);
    _scrollController.dispose();
    _filterNotifire.dispose();

    super.dispose();
  }

  void _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_scrollController.position.outOfRange) {
      context.read<FetchProductsCubit>().fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SearchHeaderDelegate(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 8, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BlocProvider(
                        create: (context) => sl<SearchSuggestionsCubit>(),
                        child: SearchProductsWidget(
                          onSelected: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              _filterNotifire.search(value);
                            } else if (value == null &&
                                _filterNotifire.searchQuery != '') {
                              _filterNotifire.search("");
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => _bottomSheet,
                        icon: const Icon(
                          Icons.format_align_center_sharp,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: _filterNotifire,
            builder: (context, child) => ProductsGrid(params: _productsParams),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Future<void> get _bottomSheet async => await showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    isDismissible: false,
    enableDrag: true,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    builder: (context) {
      return FilterComponents(
        filterData: _filterNotifire.filterData,
        onApply: (FilterData filterData) {
          context.pop();
          _filterNotifire.filter(filterData);
        },
      );
    },
  );
}

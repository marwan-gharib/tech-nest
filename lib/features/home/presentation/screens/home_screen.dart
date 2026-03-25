import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
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
  late final ScrollController _scrollController;

  FilterData _filterData = const FilterData();

  late final TextEditingController _searchController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_listener);

    _searchController = TextEditingController();

    context.read<FetchProductsCubit>().initialFetching();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listener);
    _scrollController.dispose();

    _searchController.dispose();

    super.dispose();
  }

  void _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_scrollController.position.outOfRange) {
      context.read<FetchProductsCubit>().fetchMore();
    }
  }

  Future<void> _onRefresh() async {
    _searchController.clear();

    await context.read<FetchProductsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
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
                            controller: _searchController,
                            onSelected: (value) async {
                              context.read<FetchProductsCubit>().search(
                                value ?? "",
                              );
                              Logger.logg(value.toString());
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
            const ProductsGrid(),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
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
        filterData: _filterData,
        onApply: (FilterData filterData) async {
          _filterData = filterData;
          context.read<FetchProductsCubit>().applyFilters(_filterData);
          context.pop();
        },
      );
    },
  );
}

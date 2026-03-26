import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_components.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        edgeOffset: 100,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              elevation: 0,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.95),
              surfaceTintColor: Colors.transparent,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  bottom: 68,
                  right: AppSpacing.md,
                ),
                title: Text(
                  "Discover",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  child: Row(
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
                              Logger.logg("Searched: $value");
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: AppRadius.button,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: _showBottomSheet,
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: ProductsGrid(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }

  Future<void> _showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      elevation: 24,
      shape: AppRadius.sheetShape,
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
}

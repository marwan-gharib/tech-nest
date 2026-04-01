import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_components.dart';
import 'package:tech_nest/features/home/presentation/widgets/home_app_bar.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/products_grid.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        edgeOffset: 100,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          slivers: [
            HomeAppBar(
              searchController: _searchController,
              onFilterPressed: _showBottomSheet,
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: ProductsGrid(),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxl + AppSpacing.md),
            ),
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
        return BlocProvider(
          create: (context) => sl<FetchProductsCubit>(),
          child: FilterComponents(
            filterData: _filterData,
            onApply: (FilterData filterData) async {
              _filterData = filterData;
              context.read<FetchProductsCubit>().applyFilters(_filterData);
              context.pop();
            },
          ),
        );
      },
    );
  }
}

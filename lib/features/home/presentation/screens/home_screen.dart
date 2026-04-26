import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/move_to_first_scroll_position_widget.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_components.dart';
import 'package:tech_nest/features/home/presentation/widgets/home_app_bar.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/models/filter_data.dart';
import 'package:tech_nest/features/products/presentation/widgets/shared/products_grid.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  FilterData _filterData = const FilterData();
  late final TextEditingController _searchController;
  late final ValueNotifier<bool> _showScrollToTop;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_listener);
    _searchController = TextEditingController();
    context.read<FetchProductsCubit>().initialFetching();
    _showScrollToTop = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listener);
    _scrollController.dispose();
    _searchController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  void _listener() {
    _showScrollToTop.value = _scrollController.offset > 200;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_scrollController.position.outOfRange) {
      context.read<FetchProductsCubit>().fetchMore();
    }
  }

  Future<void> _onRefresh() async {
    _searchController.clear();
    _filterData = const FilterData();
    await context.read<FetchProductsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: BlocListener<LocaleCubit, LocaleState>(
        listenWhen: (previous, current) => previous.locale != current.locale,
        listener: (context, state) {
          _onRefresh();
        },
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _onRefresh,
              edgeOffset: 0,
              displacement: 100,
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
            Positioned(
              bottom: AppSpacing.xxl,
              right: AppSpacing.md,
              child: BlocSelector<FetchProductsCubit, FetchProductsState, bool>(
                selector: (state) => state is FetchProductsLoaded,
                builder: (context, isLoaded) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _showScrollToTop,
                    builder: (context, show, _) {
                      return Visibility(
                        visible: isLoaded && show,
                        child: MoveToFirstScrollPositionWidget(
                          onTap: _scrollToTop,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToTop() {
    final double currentOffset = _scrollController.offset;
    final int durationMs =
        (500 + (currentOffset * 0.4)).clamp(500, 3000).toInt();

    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _showBottomSheet() async {
    final fetchProductsCubit = context.read<FetchProductsCubit>();

    await showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      elevation: 24,
      shape: AppRadius.sheetShape,
      builder: (_) {
        return BlocProvider.value(
          value: fetchProductsCubit,
          child: FilterComponents(
            filterData: _filterData,
            onApply: (FilterData filterData) async {
              _filterData = filterData;
              fetchProductsCubit.applyFilters(_filterData);
              context.pop();
            },
          ),
        );
      },
    );
  }
}


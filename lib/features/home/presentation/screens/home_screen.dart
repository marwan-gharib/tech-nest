import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
import 'package:tech_nest/features/home/presentation/notifires/filter_notifire.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_components.dart';
import 'package:tech_nest/features/home/presentation/widgets/search_header_delegate.dart';
import 'package:tech_nest/features/products/presentation/cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/products_grid.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FilterNotifire _filterNotifire;

  @override
  void initState() {
    _filterNotifire = FilterNotifire();

    super.initState();
  }

  @override
  void dispose() {
    _filterNotifire.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                builder: (context, child) {
                  return ProductsGrid(
                    searchLabel: _filterNotifire.searchQuery,
                    categoryId: _filterNotifire.filterData.categoryId,
                    sortType: _filterNotifire.filterData.sortType,
                    orderType: _filterNotifire.filterData.orderType,
                    minPrice: _filterNotifire.filterData.minPrice,
                    maxPrice: _filterNotifire.filterData.maxPrice,
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
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
        filterData: _filterNotifire.filterData,
        onApply: (FilterData filterData) {
          context.pop();
          _filterNotifire.filter(filterData);
        },
      );
    },
  );
}

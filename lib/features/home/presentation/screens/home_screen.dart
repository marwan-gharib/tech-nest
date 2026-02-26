import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
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
  String? _search;
  FilterData _filterData = const FilterData();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                floating: true,
                delegate: SearchHeaderDelegate(
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 2,
                          left: 8,
                          top: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BlocProvider(
                                create: (context) =>
                                    sl<SearchSuggestionsCubit>(),
                                child: SearchProductsWidget(
                                  onSelected: (value) {
                                    if (value != null &&
                                        value.trim().isNotEmpty) {
                                      setState(() => _search = value);
                                    } else if (value == null) {
                                      setState(() => _search = '');
                                    }
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () => _bottomSheet,
                                icon: const Icon(
                                  Icons.format_align_center_sharp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ProductsGrid(
                searchLabel: _search,
                categoryId: _filterData.categoryId,
                sortType: _filterData.sortType,
                orderType: _filterData.orderType,
                minPrice: _filterData.minPrice,
                maxPrice: _filterData.maxPrice,
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
        filterData: _filterData,
        onApply: (FilterData filterData) {
          context.pop();
          setState(() => _filterData = filterData);
        },
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/enums/order_type.dart';
import 'package:tech_nest/core/enums/sort_type.dart';
import 'package:tech_nest/features/categories/presentation/cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/categories_view.dart';
import 'package:tech_nest/features/home/presentation/widgets/custom_search_field.dart';
import 'package:tech_nest/features/home/presentation/widgets/radio_buttons_group.dart';
import 'package:tech_nest/features/home/presentation/widgets/search_header_delegate.dart';
import 'package:tech_nest/features/products/presentation/widgets/products_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _search = '';
  int? _categoryId;
  SortType _sortType = SortType.name;
  OrderType _orderType = OrderType.asc;

  late final ValueNotifier<bool> _showFilterList;

  late final TextEditingController _minPrice;
  late final TextEditingController _maxPrice;

  @override
  void initState() {
    _showFilterList = ValueNotifier<bool>(false);

    _minPrice = TextEditingController();
    _maxPrice = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _showFilterList.dispose();

    _minPrice.dispose();
    _maxPrice.dispose();

    super.dispose();
  }

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
                          children: [
                            Expanded(
                              child: CustomSearchField(
                                onSubmit: (value) =>
                                    setState(() => _search = value),
                              ),
                            ),
                            Center(
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.4,
                                          width: double.infinity,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                BlocProvider(
                                                  create: (context) =>
                                                      sl<FetchCategoriesCubit>()
                                                        ..fetchCategories(),
                                                  child: CategoriesView(
                                                    onCategorySelected:
                                                        (value) => setState(
                                                          () => _categoryId =
                                                              value,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 50,
                                                        vertical: 8,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      _textField(
                                                        controller: _minPrice,
                                                        label: "min price",
                                                      ),
                                                      const SizedBox(width: 30),
                                                      _textField(
                                                        controller: _maxPrice,
                                                        label: "max price",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RadioButtonsGroup<SortType>(
                                                  values: const [
                                                    SortType.name,
                                                    SortType.price,
                                                  ],
                                                  onTap: (value) {
                                                    _sortType =
                                                        value ?? _sortType;
                                                  },
                                                  isHorizontal: true,
                                                  labelBuilder: (value) {
                                                    return value.name;
                                                  },
                                                ),
                                                RadioButtonsGroup<OrderType>(
                                                  values: const [
                                                    OrderType.asc,
                                                    OrderType.desc,
                                                  ],
                                                  onTap: (value) {
                                                    _orderType =
                                                        value ?? _orderType;
                                                  },
                                                  isHorizontal: true,
                                                  labelBuilder: (value) {
                                                    return value.name;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
                categoryId: _categoryId,
                sortType: _sortType,
                orderType: _orderType,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        cursorColor: Theme.of(context).colorScheme.primary,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: _border,
          errorBorder: _border,
          disabledBorder: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          focusedErrorBorder: _border,
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimary,
          hintText: label,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).hintColor),
          isDense: true,
        ),
      ),
    );
  }

  InputBorder get _border => OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(16),
  );
}

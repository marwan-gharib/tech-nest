import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/service_locator.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/shared/search_products_widget.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/home/presentation/widgets/home_filter_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class HomeAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterPressed;

  const HomeAppBar({
    required this.searchController,
    required this.onFilterPressed,
    super.key,
  });

  static const double _expandedHeight = 120.0;
  static const double _bottomHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0,
      backgroundColor: context.colors.background.withValues(alpha: 0.95),
      surfaceTintColor: Colors.transparent,
      expandedHeight: _expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.md,
          bottom: 68,
          right: AppSpacing.md,
        ),
        title: Text(
          context.t.home.discover,
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_bottomHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: BlocProvider(
                  create: (context) => sl<SearchSuggestionsCubit>(),
                  child: BlocBuilder<SearchSuggestionsCubit, SearchSuggestionsState>(
                    builder: (context, state) {
                      return SearchProductsWidget(
                        controller: searchController,
                        hintText: context.t.home.search,
                        suggestions: state is SearchSuggestionsLoaded ? state.suggestions : [],
                        isLoading: state is SearchSuggestionsLoading,
                        onTextChanged: (query) => context.read<SearchSuggestionsCubit>().getSuggestions(searchLabel: query),
                        onClearSuggestions: () => context.read<SearchSuggestionsCubit>().clearCache(),
                        onSelected: (value) async {
                          context.read<FetchProductsCubit>().search(value ?? "");
                        },
                        onClear: () {
                          final fetchState = context.read<FetchProductsCubit>().state;
                          if (fetchState is FetchProductsLoaded &&
                              fetchState.isSearchApplied) {
                            context.read<FetchProductsCubit>().refresh();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              HomeFilterButton(onPressed: onFilterPressed),
            ],
          ),
        ),
      ),
    );
  }
}


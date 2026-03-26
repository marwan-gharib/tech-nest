import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_products_widget.dart';
import 'package:tech_nest/features/home/presentation/widgets/home_filter_button.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0,
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      surfaceTintColor: Colors.transparent,
      expandedHeight: _expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.md,
          bottom: 68,
          right: AppSpacing.md,
        ),
        title: Text(
          "Discover",
          style: theme.textTheme.headlineMedium?.copyWith(
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
                  child: SearchProductsWidget(
                    controller: searchController,
                    onSelected: (value) async {
                      context.read<FetchProductsCubit>().search(value ?? "");
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

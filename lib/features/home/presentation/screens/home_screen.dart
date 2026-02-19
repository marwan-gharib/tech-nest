import 'package:flutter/material.dart';
import 'package:tech_nest/features/home/presentation/widgets/search_sliver_app_bar.dart';
import 'package:tech_nest/features/products/presentation/widgets/products_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [SearchSliverAppBar(), ProductsGrid()],
          ),
        ),
      ),
    );
  }
}

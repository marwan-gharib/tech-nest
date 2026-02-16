import 'package:flutter/material.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Products")),
        body: GridView.count(
          crossAxisCount: 2,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          mainAxisSpacing: 10,
          children: const [
            ProductCard(),
            ProductCard(),
            ProductCard(),
            ProductCard(),
            ProductCard(),
          ],
        ),
      ),
    );
  }
}

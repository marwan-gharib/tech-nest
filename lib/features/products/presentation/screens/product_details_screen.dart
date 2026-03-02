import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/entities/product_entity.dart';
import 'package:tech_nest/features/products/presentation/widgets/custom_counter.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _productImage(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadiusGeometry.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Category: ${product.category.name}",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(
                                  fontSize: 20,
                                  color: Theme.of(
                                    context,
                                  ).shadowColor.withValues(alpha: 0.5),
                                ),
                          ),
                          _productPrice(context),
                          Text(
                            "Stock: ${product.stock}",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      CustomCounter(stock: product.stock),
                      const SizedBox(width: 14),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(
                        context,
                      ).shadowColor.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(
                        context,
                      ).shadowColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: product.stock > 0 ? () {} : null,
                      child: const Text("Add to Cart"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: InkWell(
              onTap: () => context.pop(),
              child: Container(
                height: 22,
                width: 28,
                margin: const EdgeInsets.only(left: 30, top: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productImage(BuildContext context) => SizedBox(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.4,
    child: CachedNetworkImage(
      imageUrl: Endpoints.baseUrl + product.imgUrl,
      fit: BoxFit.fill,
      width: double.infinity,
    ),
  );

  Widget _productPrice(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Price: ${product.price.toStringAsFixed(1)}",
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: 20,
          color: Theme.of(context).hintColor,
        ),
        children: [
          TextSpan(
            text: " \$",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 20,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

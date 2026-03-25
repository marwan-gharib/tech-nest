import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/widgets/build_price.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/products/presentation/widgets/custom_counter.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({required this.productId, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantityCounter = 1;
  late Product product;
  bool _isProductFound = false;

  @override
  void initState() {
    super.initState();
    try {
      product = context.read<FetchProductsCubit>().state.products.firstWhere((p) => p.id == widget.productId);
      _isProductFound = true;
    } catch (_) {
      try {
        product = context.read<CategoryProductsCubit>().state.products!.firstWhere((p) => p.id == widget.productId);
        _isProductFound = true;
      } catch (_) {
        _isProductFound = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isProductFound) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Product not found")),
      );
    }

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
                                  ).shadowColor.withValues(alpha: 0.7),
                                ),
                          ),
                          BuildPrice(
                            price: product.price,
                            isLabeled: true,
                          ),
                          Text(
                            "Stock: ${product.stock > 0 ? product.stock.toString() : "Out of stock"}",
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).shadowColor.withValues(alpha: 0.6),
                                  decoration: product.stock > 0
                                      ? null
                                      : TextDecoration.lineThrough,
                                ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      CustomCounter(
                        maxCount: product.stock,
                        onChanged: (value) => quantityCounter = value,
                      ),
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
                  BlocConsumer<CartCubit, CartState>(
                    listener: _listener,
                    builder: _builder,
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

  void _listener(BuildContext context, CartState state) {
    if (state is CartFailed) {
      customSnackBar(context, message: state.message);
    }
  }

  Widget _builder(BuildContext context, CartState state) {
    return Center(
      child: state is CartLoading
          ? const CircularProgressIndicator(strokeAlign: 3)
          : ElevatedButton(
              onPressed: product.stock > 0
                  ? () => context.read<CartCubit>().add(
                      productId: product.id,
                      quantity: quantityCounter,
                    )
                  : null,
              child: const Text("Add to Cart"),
            ),
    );
  }
}

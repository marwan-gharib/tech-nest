import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/add_to_cart_action.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_description_section.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_details_back_button.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_hero_image.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_info_section.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({required this.productId, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantityCounter = 1;
  late ProductEntity product;
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

    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          ProductHeroImage(product: product),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(
                top: AppSpacing.lg,
                left: AppSpacing.md,
                right: AppSpacing.md,
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: AppRadius.sheet,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.md,
                  children: [
                    ProductInfoSection(
                      product: product,
                      onQuantityChanged: (value) => quantityCounter = value,
                    ),
                    ProductDescriptionSection(description: product.description),
                    const SizedBox(height: AppSpacing.xl),
                    BlocConsumer<CartCubit, CartState>(
                      listener: _listener,
                      builder: (context, state) {
                        return AddToCartAction(
                          state: state,
                          onAdd: () => context.read<CartCubit>().add(
                                productId: product.id,
                                quantity: quantityCounter,
                              ),
                          isAvailable: product.stock > 0,
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
          const ProductDetailsBackButton(),
        ],
      ),
    );
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartMutationFailed) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }
}

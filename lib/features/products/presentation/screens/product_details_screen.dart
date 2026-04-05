import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/shared/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/shared/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/presentation/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/products/presentation/widgets/add_to_cart_action.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_description_section.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_details_back_button.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_hero_image.dart';
import 'package:tech_nest/features/products/presentation/widgets/product_info_section.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsScreen({required this.product, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantityCounter = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;

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
              height: MediaQuery.sizeOf(context).height * 0.45,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: AppRadius.sheet,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: AppRadius.sm,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.md,
                  children: [
                    ProductInfoSection(
                      product: product,
                      onQuantityChanged: (value) => quantityCounter = value,
                    ),
                    const Divider(),
                    ProductDescriptionSection(description: product.description),
                    const SizedBox(height: AppSpacing.xl),
                    BlocListener<CartCubit, CartState>(
                      listenWhen: (previous, current) => current is CartLoaded,
                      listener: _listener,
                      child: AddToCartAction(
                        state: context.read<CartCubit>().state,
                        productId: product.id,
                        onAdd: () => context.read<CartCubit>().add(
                          productId: product.id,
                          quantity: quantityCounter,
                        ),
                        isAvailable: product.stock > 0,
                      ),
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
    if (ModalRoute.of(context)?.isCurrent != true) return;

    if (state is CartLoaded) {
      if (state.mutationFailure != null) {
        CustomSnackBar.showError(context, failure: state.mutationFailure!);
        context.read<CartCubit>().clearMutationError();
      }
    }
  }
}

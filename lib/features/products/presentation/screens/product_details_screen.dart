import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/widgets/loading_more_indicator.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/get_product_cubit/get_product_cubit.dart';
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
  late final ValueNotifier<int> _quantityNotifier;

  @override
  void initState() {
    super.initState();
    _quantityNotifier = ValueNotifier<int>(1);
  }

  @override
  void dispose() {
    _quantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProductCubit, GetProductState>(
      builder: (context, state) {
        return switch (state) {
          GetProductInitial() ||
          GetProductLoading() => const Center(child: LoadingMoreIndicator()),
          GetProductError(failure: final failure) => RemoteDataFailureView(
            failure: failure,
            onRetry: () =>
                context.read<GetProductCubit>().getProduct(widget.productId),
          ),
          GetProductLoaded(product: final product) => Stack(
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
                    color: context.colors.background,
                    borderRadius: AppRadius.sheet,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.textPrimary.withValues(
                          alpha: 0.05,
                        ),
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
                        FadeInSlide(
                          delay: const Duration(milliseconds: 100),
                          child: ProductInfoSection(
                            product: product,
                            onQuantityChanged: (value) =>
                                _quantityNotifier.value = value,
                          ),
                        ),
                        const FadeInSlide(
                          delay: Duration(milliseconds: 200),
                          child: Divider(),
                        ),
                        FadeInSlide(
                          delay: const Duration(milliseconds: 300),
                          child: ProductDescriptionSection(
                            description: product.description,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        BlocListener<CartCubit, CartState>(
                          listenWhen: (previous, current) =>
                              current is CartLoaded,
                          listener: _listener,
                          child: ValueListenableBuilder<int>(
                            valueListenable: _quantityNotifier,
                            builder: (context, quantity, child) {
                              return BlocBuilder<CartCubit, CartState>(
                                builder: (context, state) {
                                  final bool isLoading =
                                      state is CartLoading ||
                                      (state is CartLoaded && state.isMutating);
                                  final bool isInCart =
                                      state is CartLoaded &&
                                      state.cart.items.any(
                                        (item) => item.product.id == product.id,
                                      );

                                  return FadeInSlide(
                                    delay: const Duration(milliseconds: 400),
                                    child: AddToCartAction(
                                      isLoading: isLoading,
                                      isInCart: isInCart,
                                      isAvailable: product.stock > 0,
                                      onAdd: () {
                                        HapticFeedback.heavyImpact();
                                        context.read<CartCubit>().add(
                                          productId: product.id,
                                          quantity: quantity,
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
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
        };
      },
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

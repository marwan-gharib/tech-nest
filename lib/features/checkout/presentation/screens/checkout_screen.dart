import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_state.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/checkout_address_card.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/checkout_section_title.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/checkout_summary_card.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/confirm_order_button.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrderCubit, CreateOrderState>(
      listener: (context, state) {
        if (state is CreateOrderSuccess) {
          context.pop();
          context.read<CartCubit>().clearCart();
          context.go(
            '${Routes.ordersScreenPath}/${Routes.orderDetailsScreenPath}',
            extra: state.orderId,
          );
        } else if (state is CreateOrderFailed) {
          CustomSnackBar.showError(context, failure: state.failure);
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(context.t.cart.checkout),
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  CheckoutSectionTitle(title: context.t.cart.summary),
                  const SizedBox(height: AppSpacing.md),
                  const CheckoutSummaryCard(),
                  const SizedBox(height: AppSpacing.xl),
                  CheckoutSectionTitle(title: context.t.orders.shippingAddress),
                  const SizedBox(height: AppSpacing.md),
                  CheckoutAddressCard(
                    onLocationSelected: (location) => _address = location ?? '',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ConfirmOrderButton(
          onPressed: () {
            if (_address.isEmpty) {
              CustomSnackBar.show(
                context,
                message: context.t.checkout.selectAddressError,
              );
              return;
            }
            context.read<CreateOrderCubit>().createOrder(
              CreateOrderParams(
                shippingAddress: _address,
                billingAddress: _address,
              ),
            );
          },
        ),
      ),
    );
  }
}

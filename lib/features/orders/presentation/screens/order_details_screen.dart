import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/date_formatter.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_addresses.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_header.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_item_card.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_summary.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({required this.orderId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderDetailsCubit, OrderDetailsState>(
      listenWhen: (previous, current) {
        if (previous is OrderDetailsLoaded && current is OrderDetailsLoaded) {
          return previous.cancelFailure != current.cancelFailure ||
              previous.isCancelledSuccessfully !=
                  current.isCancelledSuccessfully;
        }
        return false;
      },
      listener: (context, state) {
        if (state is OrderDetailsLoaded) {
          if (state.cancelFailure != null) {
            CustomSnackBar.showError(context, failure: state.cancelFailure!);
          }
          if (state.isCancelledSuccessfully) {
            CustomSnackBar.showSuccess(
              context,
              message: context.t.orders.cancelSuccess,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.t.orders.details), elevation: 0),
        body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is OrderDetailsLoading || state is OrderDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderDetailsFailed) {
              return RemoteDataFailureView(
                failure: state.failure,
                onRetry: () => context
                    .read<OrderDetailsCubit>()
                    .fetchOrderDetails(orderId),
              );
            }

            if (state is OrderDetailsLoaded) {
              final order = state.order;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        FadeInSlide(
                          delay: const Duration(milliseconds: 100),
                          child: OrderDetailsHeader(order: order),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        FadeInSlide(
                          delay: const Duration(milliseconds: 150),
                          child: Text(
                            context.t.orders.date(
                              date: DateFormatter.format(order.createdAt),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                          ),
                        ),
                        const Divider(height: AppSpacing.xl),
                        FadeInSlide(
                          delay: const Duration(milliseconds: 200),
                          child: OrderDetailsAddresses(order: order),
                        ),
                        const Divider(height: AppSpacing.xl),
                        FadeInSlide(
                          delay: const Duration(milliseconds: 250),
                          child: Text(
                            context.t.orders.orderItems,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => FadeInSlide(
                              delay: Duration(milliseconds: 300 + (index * 50)),
                              child: OrderDetailsItemCard(item: order.items[index]),
                            ),
                            childCount: order.items.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        FadeInSlide(
                          delay: const Duration(milliseconds: 400),
                          child: OrderDetailsSummary(
                            order: order,
                            isCancelling: state.isCancelling,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ]),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

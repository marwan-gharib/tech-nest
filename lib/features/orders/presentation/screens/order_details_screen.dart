import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/date_formatter.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_addresses.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_header.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_item_card.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_details_summary.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.cancelFailure!.message)),
            );
          }
          if (state.isCancelledSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.t.orders.cancelSuccess)),
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
              return Center(child: Text(state.failure.message));
            }

            if (state is OrderDetailsLoaded) {
              final order = state.order;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        OrderDetailsHeader(order: order),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          context.t.orders.date(
                            date: DateFormatter.format(order.createdAt),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                              ),
                        ),
                        const Divider(height: AppSpacing.xl),
                        OrderDetailsAddresses(order: order),
                        const Divider(height: AppSpacing.xl),
                        Text(
                          context.t.orders.orderItems,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => OrderDetailsItemCard(
                          item: order.items[index],
                        ),
                        childCount: order.items.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        OrderDetailsSummary(
                          order: order,
                          isCancelling: state.isCancelling,
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

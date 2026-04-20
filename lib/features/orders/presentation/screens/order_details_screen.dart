import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';
import 'package:tech_nest/features/orders/presentation/widgets/order_status_chip.dart';
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
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#${order.id}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            OrderStatusChip(status: order.status),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          context.t.orders.date(
                            date: _formatDate(order.createdAt),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                        const Divider(height: AppSpacing.xl),

                        // Addresses
                        Text(
                          context.t.orders.shippingAddress,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(order.shippingAddress),
                        const SizedBox(height: AppSpacing.md),

                        Text(
                          context.t.orders.billingAddress,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(order.billingAddress),
                        const Divider(height: AppSpacing.xl),

                        // Items
                        Text(
                          context.t.orders.orderItems,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ]),
                    ),
                  ),

                  // Items List
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = order.items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor.withValues(alpha: 0.1),
                            ),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    ),
                              ),
                            ),
                            title: Text(item.name),
                            subtitle: Text(
                              '${context.t.cart.items}: ${item.quantity}',
                            ),
                            trailing: Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        );
                      }, childCount: order.items.length),
                    ),
                  ),

                  // Total & Cancel Button
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const Divider(height: AppSpacing.xl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.t.cart.total,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              '\$${order.totalPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        if (order.status == OrderStatus.pending) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: Colors.red,
                                elevation: 0,
                              ),
                              onPressed: state.isCancelling
                                  ? null
                                  : () => _showCancelConfirmation(
                                      context,
                                      order.id,
                                    ),
                              child: state.isCancelling
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(context.t.orders.cancelOrder),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateString;
    }
  }

  void _showCancelConfirmation(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.t.orders.cancelOrder),
        content: Text(context.t.orders.cancelConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.t.orders.cancelNo),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<OrderDetailsCubit>().cancelOrder(orderId);
            },
            child: Text(context.t.orders.cancelYes),
          ),
        ],
      ),
    );
  }
}

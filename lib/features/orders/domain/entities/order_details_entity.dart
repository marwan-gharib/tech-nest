import 'package:tech_nest/features/orders/domain/entities/order_item_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';

class OrderDetailsEntity {
  final int id;
  final double totalPrice;
  final OrderStatus status;
  final String shippingAddress;
  final String billingAddress;
  final String createdAt;
  final String updatedAt;
  final List<OrderItemEntity> items;

  const OrderDetailsEntity({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.shippingAddress,
    required this.billingAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });
}

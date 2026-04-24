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

  OrderDetailsEntity copyWith({
    int? id,
    double? totalPrice,
    OrderStatus? status,
    String? shippingAddress,
    String? billingAddress,
    String? createdAt,
    String? updatedAt,
    List<OrderItemEntity>? items,
  }) {
    return OrderDetailsEntity(
      id: id ?? this.id,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }
}

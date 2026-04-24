import 'package:tech_nest/features/orders/domain/enums/order_status.dart';

class OrderEntity {
  final int id;
  final double totalPrice;
  final OrderStatus status;
  final String createdAt;
  final String updatedAt;

  const OrderEntity({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderEntity copyWith({
    int? id,
    double? totalPrice,
    OrderStatus? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

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
}

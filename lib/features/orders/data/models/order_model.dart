import 'package:equatable/equatable.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';

class OrderModel extends Equatable {
  final int id;
  final double totalPrice;
  final String status;
  final String createdAt;
  final String updatedAt;

  const OrderModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      totalPrice: totalPrice,
      status: OrderStatus.fromString(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, totalPrice, status, createdAt, updatedAt];
}

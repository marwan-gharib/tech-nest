import 'package:equatable/equatable.dart';
import 'package:tech_nest/features/orders/data/models/order_item_model.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';

class OrderDetailsModel extends Equatable {
  final int id;
  final double totalPrice;
  final String status;
  final String shippingAddress;
  final String billingAddress;
  final String createdAt;
  final String updatedAt;
  final List<OrderItemModel> items;

  const OrderDetailsModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.shippingAddress,
    required this.billingAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      shippingAddress: json['shipping_address'] as String,
      billingAddress: json['billing_address'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_price': totalPrice,
      'status': status,
      'shipping_address': shippingAddress,
      'billing_address': billingAddress,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      id: id,
      totalPrice: totalPrice,
      status: OrderStatus.fromString(status),
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    totalPrice,
    status,
    shippingAddress,
    billingAddress,
    createdAt,
    updatedAt,
    items,
  ];
}

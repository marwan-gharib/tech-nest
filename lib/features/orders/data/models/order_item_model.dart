import 'package:equatable/equatable.dart';
import 'package:tech_nest/features/orders/domain/entities/order_item_entity.dart';

class OrderItemModel extends Equatable {
  final int orderItemId;
  final int quantity;
  final double price;
  final int productId;
  final String name;
  final String imageUrl;

  const OrderItemModel({
    required this.orderItemId,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.name,
    required this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['order_item_id'] as int,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      productId: json['product_id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_item_id': orderItemId,
      'quantity': quantity,
      'price': price,
      'product_id': productId,
      'name': name,
      'image_url': imageUrl,
    };
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      orderItemId: orderItemId,
      quantity: quantity,
      price: price,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    orderItemId,
    quantity,
    price,
    productId,
    name,
    imageUrl,
  ];
}

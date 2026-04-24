import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

class CartItem {
  final int id;
  final int quantity;
  final ProductEntity product;

  CartItem({required this.id, required this.quantity, required this.product});

  CartItem copyWith({int? id, int? quantity, ProductEntity? product}) {
    return CartItem(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}

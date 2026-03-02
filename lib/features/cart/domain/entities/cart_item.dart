import 'package:tech_nest/core/entities/product_entity.dart';

class CartItem {
  final int id;
  final int quantity;
  final Product product;

  CartItem({required this.id, required this.quantity, required this.product});
}

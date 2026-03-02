import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';

class Cart {
  final List<CartItem> items;
  final int totalQuantity;
  final int totalPrice;
  final int deliveryCharges;
  final int grandTotal;

  Cart({
    required this.items,
    required this.totalQuantity,
    required this.totalPrice,
    required this.deliveryCharges,
    required this.grandTotal,
  });

  Cart _copyWith({
    List<CartItem>? items,
    int? totalQuantity,
    int? totalPrice,
    int? deliveryCharges,
    int? grandTotal,
  }) {
    return Cart(
      items: items ?? this.items,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      grandTotal: grandTotal ?? this.grandTotal,
    );
  }

  Cart recalculate(List<CartItem> newItems) {
    final totalQty = newItems.fold<int>(0, (sum, item) => sum + item.quantity);

    final totalPrice = newItems.fold(
      0,
      (sum, item) => sum + (item.product.price.toInt() * item.quantity),
    );

    const delivery = 50;

    final grand = totalPrice + delivery;

    return _copyWith(
      items: newItems,
      totalQuantity: totalQty,
      totalPrice: totalPrice,
      deliveryCharges: delivery,
      grandTotal: grand,
    );
  }
}

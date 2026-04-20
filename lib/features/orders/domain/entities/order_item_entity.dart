class OrderItemEntity {
  final int orderItemId;
  final int quantity;
  final double price;
  final int productId;
  final String name;
  final String imageUrl;

  const OrderItemEntity({
    required this.orderItemId,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.name,
    required this.imageUrl,
  });
}

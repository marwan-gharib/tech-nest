class CreateOrderParams {
  final String shippingAddress;
  final String billingAddress;

  const CreateOrderParams({
    required this.shippingAddress,
    required this.billingAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'shipping_address': shippingAddress,
      'billing_address': billingAddress,
    };
  }
}

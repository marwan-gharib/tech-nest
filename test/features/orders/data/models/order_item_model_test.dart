import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/orders/data/models/order_item_model.dart';
import 'package:tech_nest/features/orders/domain/entities/order_item_entity.dart';

void main() {
  const tModel = OrderItemModel(
    orderItemId: 1,
    quantity: 2,
    price: 149.50,
    productId: 10,
    name: 'Mechanical Keyboard',
    imageUrl: 'keyboard.png',
  );

  final tJson = {
    'order_item_id': 1,
    'quantity': 2,
    'price': 149.50,
    'product_id': 10,
    'name': 'Mechanical Keyboard',
    'image_url': 'keyboard.png',
  };

  group('OrderItemModel', () {
    test('maps from JSON correctly', () {
      final result = OrderItemModel.fromJson(tJson);

      expect(result, tModel);
    });

    test('maps integer price to double', () {
      final json = Map<String, dynamic>.from(tJson)..['price'] = 150;

      final result = OrderItemModel.fromJson(json);

      expect(result.price, 150.0);
    });

    test('maps to JSON correctly', () {
      final result = tModel.toJson();

      expect(result, tJson);
    });

    test('maps to OrderItemEntity correctly', () {
      final result = tModel.toEntity();

      expect(result, isA<OrderItemEntity>());
      expect(result.orderItemId, tModel.orderItemId);
      expect(result.quantity, tModel.quantity);
      expect(result.price, tModel.price);
      expect(result.productId, tModel.productId);
      expect(result.name, tModel.name);
      expect(result.imageUrl, tModel.imageUrl);
    });

    test('throws TypeError when required field is missing', () {
      final json = Map<String, dynamic>.from(tJson)..remove('name');

      expect(() => OrderItemModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws TypeError when field type is invalid', () {
      final json = Map<String, dynamic>.from(tJson)..['quantity'] = '2';

      expect(() => OrderItemModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}

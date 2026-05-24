import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/orders/data/models/order_details_model.dart';
import 'package:tech_nest/features/orders/data/models/order_item_model.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';

void main() {
  const tItemModel = OrderItemModel(
    orderItemId: 1,
    quantity: 2,
    price: 149.50,
    productId: 10,
    name: 'Mechanical Keyboard',
    imageUrl: 'keyboard.png',
  );

  const tModel = OrderDetailsModel(
    id: 7,
    totalPrice: 349.99,
    status: 'confirmed',
    shippingAddress: 'Cairo, Egypt',
    billingAddress: 'Giza, Egypt',
    createdAt: '2026-05-20T10:00:00Z',
    updatedAt: '2026-05-21T10:00:00Z',
    items: [tItemModel],
  );

  final tItemJson = {
    'order_item_id': 1,
    'quantity': 2,
    'price': 149.50,
    'product_id': 10,
    'name': 'Mechanical Keyboard',
    'image_url': 'keyboard.png',
  };

  final tJson = {
    'id': 7,
    'total_price': 349.99,
    'status': 'confirmed',
    'shipping_address': 'Cairo, Egypt',
    'billing_address': 'Giza, Egypt',
    'created_at': '2026-05-20T10:00:00Z',
    'updated_at': '2026-05-21T10:00:00Z',
    'items': [tItemJson],
  };

  group('OrderDetailsModel', () {
    test('maps from JSON correctly', () {
      final result = OrderDetailsModel.fromJson(tJson);

      expect(result, tModel);
    });

    test('uses empty items list when items field is missing', () {
      final json = Map<String, dynamic>.from(tJson)..remove('items');

      final result = OrderDetailsModel.fromJson(json);

      expect(result.items, isEmpty);
    });

    test('uses empty items list when items field is null', () {
      final json = Map<String, dynamic>.from(tJson)..['items'] = null;

      final result = OrderDetailsModel.fromJson(json);

      expect(result.items, isEmpty);
    });

    test('maps integer total price to double', () {
      final json = Map<String, dynamic>.from(tJson)..['total_price'] = 350;

      final result = OrderDetailsModel.fromJson(json);

      expect(result.totalPrice, 350.0);
    });

    test('maps to JSON correctly', () {
      final result = tModel.toJson();

      expect(result, tJson);
    });

    test('maps to OrderDetailsEntity correctly', () {
      final result = tModel.toEntity();

      expect(result, isA<OrderDetailsEntity>());
      expect(result.id, tModel.id);
      expect(result.totalPrice, tModel.totalPrice);
      expect(result.status, OrderStatus.confirmed);
      expect(result.shippingAddress, tModel.shippingAddress);
      expect(result.billingAddress, tModel.billingAddress);
      expect(result.createdAt, tModel.createdAt);
      expect(result.updatedAt, tModel.updatedAt);
      expect(result.items, hasLength(1));
      expect(result.items.first.productId, tItemModel.productId);
    });

    test('defaults unknown status to pending when mapping to entity', () {
      final model = OrderDetailsModel.fromJson({...tJson, 'status': 'unknown'});

      final result = model.toEntity();

      expect(result.status, OrderStatus.pending);
    });

    test('throws TypeError when required field is missing', () {
      final json = Map<String, dynamic>.from(tJson)..remove('shipping_address');

      expect(() => OrderDetailsModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws TypeError when field type is invalid', () {
      final json = Map<String, dynamic>.from(tJson)..['id'] = '7';

      expect(() => OrderDetailsModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws TypeError when item shape is invalid', () {
      final json = Map<String, dynamic>.from(tJson)
        ..['items'] = [
          {'order_item_id': 'invalid'},
        ];

      expect(() => OrderDetailsModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}

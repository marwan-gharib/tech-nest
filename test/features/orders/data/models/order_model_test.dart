import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/orders/data/models/order_model.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';

void main() {
  const tModel = OrderModel(
    id: 7,
    totalPrice: 349.99,
    status: 'pending',
    createdAt: '2026-05-20T10:00:00Z',
    updatedAt: '2026-05-21T10:00:00Z',
  );

  final tJson = {
    'id': 7,
    'total_price': 349.99,
    'status': 'pending',
    'created_at': '2026-05-20T10:00:00Z',
    'updated_at': '2026-05-21T10:00:00Z',
  };

  group('OrderModel', () {
    test('maps from JSON correctly', () {
      final result = OrderModel.fromJson(tJson);

      expect(result, tModel);
    });

    test('maps integer total price to double', () {
      final json = Map<String, dynamic>.from(tJson)..['total_price'] = 350;

      final result = OrderModel.fromJson(json);

      expect(result.totalPrice, 350.0);
    });

    test('maps to JSON correctly', () {
      final result = tModel.toJson();

      expect(result, tJson);
    });

    test('maps to OrderEntity correctly', () {
      final result = tModel.toEntity();

      expect(result, isA<OrderEntity>());
      expect(result.id, tModel.id);
      expect(result.totalPrice, tModel.totalPrice);
      expect(result.status, OrderStatus.pending);
      expect(result.createdAt, tModel.createdAt);
      expect(result.updatedAt, tModel.updatedAt);
    });

    test('defaults unknown status to pending when mapping to entity', () {
      const model = OrderModel(
        id: 8,
        totalPrice: 120,
        status: 'unknown',
        createdAt: '2026-05-20T10:00:00Z',
        updatedAt: '2026-05-21T10:00:00Z',
      );

      final result = model.toEntity();

      expect(result.status, OrderStatus.pending);
    });

    test('throws TypeError when required field is missing', () {
      final json = Map<String, dynamic>.from(tJson)..remove('id');

      expect(() => OrderModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws TypeError when field type is invalid', () {
      final json = Map<String, dynamic>.from(tJson)..['total_price'] = '349.99';

      expect(() => OrderModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}

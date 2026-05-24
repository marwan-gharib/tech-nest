import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/cart/data/models/cart_model.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';

void main() {
  final tCartModel = CartModel(
    items: [],
    totalQuantity: 2,
    totalPrice: 2000,
    deliveryCharges: 50,
    grandTotal: 2050,
  );

  final tJson = {
    ApiKeys.items: [],
    ApiKeys.totalQuantity: 2,
    ApiKeys.totalPrice: 2000,
    ApiKeys.deliveryCharges: 50,
    ApiKeys.grandTotal: 2050,
  };

  test('should be a subclass of Cart entity', () {
    expect(tCartModel.toEntity(), isA<Cart>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON is valid', () {
      final result = CartModel.fromJson(tJson);

      expect(result.items, isEmpty);
      expect(result.totalQuantity, tCartModel.totalQuantity);
      expect(result.totalPrice, tCartModel.totalPrice);
      expect(result.deliveryCharges, tCartModel.deliveryCharges);
      expect(result.grandTotal, tCartModel.grandTotal);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tCartModel.toJson();

      expect(result, tJson);
    });
  });

  group('toEntity', () {
    test('should map model to entity correctly', () {
      final result = tCartModel.toEntity();

      expect(result.items, isEmpty);
      expect(result.totalQuantity, tCartModel.totalQuantity);
      expect(result.totalPrice, tCartModel.totalPrice);
      expect(result.deliveryCharges, tCartModel.deliveryCharges);
      expect(result.grandTotal, tCartModel.grandTotal);
    });
  });
}

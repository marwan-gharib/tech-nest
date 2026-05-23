import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/cart/data/models/cart_item_model.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/products/data/models/product_model.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';

void main() {
  final tProductModel = ProductModel(
    id: 1,
    name: 'Product 1',
    description: 'Desc',
    price: 1000.0,
    stock: 10,
    category: CategoryModel(id: 1, name: 'Cat', imgUrl: 'img.png'),
    imgUrl: 'img.jpg',
  );

  final tCartItemModel = CartItemModel(
    id: 1,
    quantity: 2,
    productModel: tProductModel,
  );

  final tJson = {
    ApiKeys.id: 1,
    ApiKeys.quantity: 2,
    ApiKeys.product: tProductModel.toJson(),
  };

  test('should be a subclass of CartItemEntity', () {
    expect(tCartItemModel.toEntity(), isA<CartItem>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON is valid', () {
      final result = CartItemModel.fromJson(tJson);

      expect(result.id, tCartItemModel.id);
      expect(result.quantity, tCartItemModel.quantity);
      expect(result.productModel.id, tCartItemModel.productModel.id);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tCartItemModel.toJson();

      expect(result, tJson);
    });
  });

  group('toEntity', () {
    test('should map model to entity correctly', () {
      final result = tCartItemModel.toEntity();

      expect(result.id, tCartItemModel.id);
      expect(result.quantity, tCartItemModel.quantity);
      expect(result.product.id, tCartItemModel.productModel.id);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';
import 'package:tech_nest/features/products/data/models/product_model.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

void main() {
  final tCategoryModel = CategoryModel(
    id: 1,
    name: 'Electronics',
    imgUrl: 'electronics.png',
  );

  final tProductModel = ProductModel(
    id: 1,
    name: 'Laptop',
    description: 'A powerful laptop',
    price: 1500.0,
    stock: 5,
    category: tCategoryModel,
    imgUrl: 'laptop.png',
  );

  final tJson = {
    ApiKeys.id: 1,
    ApiKeys.name: 'Laptop',
    ApiKeys.description: 'A powerful laptop',
    ApiKeys.price: 1500.0,
    ApiKeys.stock: 5,
    ApiKeys.category: {
      ApiKeys.id: 1,
      ApiKeys.name: 'Electronics',
      ApiKeys.imgUrl: 'electronics.png',
    },
    ApiKeys.imgUrl: 'laptop.png',
  };

  group('ProductModel', () {
    test('should map from JSON correctly', () {
      final result = ProductModel.fromJson(tJson);

      expect(result.id, equals(tProductModel.id));
      expect(result.name, equals(tProductModel.name));
      expect(result.description, equals(tProductModel.description));
      expect(result.price, equals(tProductModel.price));
      expect(result.stock, equals(tProductModel.stock));
      expect(result.category.id, equals(tProductModel.category.id));
      expect(result.imgUrl, equals(tProductModel.imgUrl));
    });

    test('should map from JSON correctly with missing imgUrl', () {
      final jsonWithMissingImage = Map<String, dynamic>.from(tJson)
        ..remove(ApiKeys.imgUrl);

      final result = ProductModel.fromJson(jsonWithMissingImage);

      expect(result.imgUrl, equals(''));
    });

    test('should parse id correctly when it comes as string', () {
      final jsonWithStringId = Map<String, dynamic>.from(tJson)
        ..[ApiKeys.id] = '1';

      final result = ProductModel.fromJson(jsonWithStringId);

      expect(result.id, equals(1));
    });

    test('should map to JSON correctly', () {
      final result = tProductModel.toJson();

      expect(result, equals(tJson));
    });

    test('should map to Entity correctly', () {
      final result = tProductModel.toEntity();

      expect(result, isA<ProductEntity>());
      expect(result.id, equals(tProductModel.id));
      expect(result.name, equals(tProductModel.name));
      expect(result.description, equals(tProductModel.description));
      expect(result.price, equals(tProductModel.price));
      expect(result.stock, equals(tProductModel.stock));
      expect(result.category.id, equals(tProductModel.category.id));
      expect(result.imgUrl, equals(tProductModel.imgUrl));
    });
  });
}

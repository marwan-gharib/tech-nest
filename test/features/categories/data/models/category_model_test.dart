import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';

void main() {
  final tCategoryModel = CategoryModel(
    id: 1,
    name: 'Electronics',
    imgUrl: 'https://example.com/img.png',
  );

  group('CategoryModel', () {
    test('should correctly convert to CategoryEntity', () {
      final result = tCategoryModel.toEntity();

      expect(result, isA<CategoryEntity>());
      expect(result.id, equals(1));
      expect(result.name, equals('Electronics'));
      expect(result.imgUrl, equals('https://example.com/img.png'));
    });

    test(
      'should return a valid model when fromJson is called with valid JSON',
      () {
        final Map<String, dynamic> jsonMap = {
          ApiKeys.id: 1,
          ApiKeys.name: 'Electronics',
          ApiKeys.imgUrl: 'https://example.com/img.png',
        };

        final result = CategoryModel.fromJson(jsonMap);

        expect(result.id, equals(1));
        expect(result.name, equals('Electronics'));
        expect(result.imgUrl, equals('https://example.com/img.png'));
      },
    );

    test(
      'should return a valid model with empty imgUrl when imgUrl is missing in JSON',
      () {
        final Map<String, dynamic> jsonMap = {
          ApiKeys.id: 1,
          ApiKeys.name: 'Electronics',
        };

        final result = CategoryModel.fromJson(jsonMap);

        expect(result.id, equals(1));
        expect(result.name, equals('Electronics'));
        expect(result.imgUrl, equals(''));
      },
    );

    test(
      'should return a JSON map containing proper data when toJson is called',
      () {
        final result = tCategoryModel.toJson();

        final expectedMap = {
          ApiKeys.id: 1,
          ApiKeys.name: 'Electronics',
          ApiKeys.imgUrl: 'https://example.com/img.png',
        };
        expect(result, equals(expectedMap));
      },
    );
  });
}

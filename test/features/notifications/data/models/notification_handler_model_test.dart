import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/notifications/data/models/notification_handler_model.dart';

void main() {
  group('NotificationHandlerModel', () {
    test('maps from JSON correctly when entity is a map', () {
      final json = {
        ApiKeys.type: 'ORDER',
        ApiKeys.entity: {ApiKeys.type: 'order', ApiKeys.id: 22},
      };

      final result = NotificationHandlerModel.fromJson(json);

      expect(result.type, 'ORDER');
      expect(result.entityType, 'order');
      expect(result.entityId, 22);
    });

    test('maps from JSON correctly when entity is an encoded JSON string', () {
      final json = {
        ApiKeys.type: 'PRODUCT',
        ApiKeys.entity: '{"type":"product","id":17}',
      };

      final result = NotificationHandlerModel.fromJson(json);

      expect(result.type, 'PRODUCT');
      expect(result.entityType, 'product');
      expect(result.entityId, 17);
    });

    test('uses default values when type and entity keys are missing', () {
      final json = <String, dynamic>{};

      final result = NotificationHandlerModel.fromJson(json);

      expect(result.type, '');
      expect(result.entityType, '');
      expect(result.entityId, 0);
    });

    test('throws FormatException when entity string is invalid JSON', () {
      final json = {
        ApiKeys.type: 'ORDER',
        ApiKeys.entity: 'not-json',
      };

      expect(() => NotificationHandlerModel.fromJson(json), throwsA(isA<FormatException>()));
    });
  });
}

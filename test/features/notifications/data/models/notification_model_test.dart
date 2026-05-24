import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/notifications/data/models/notification_model.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';

void main() {
  final tCreatedAt = DateTime.parse('2026-05-20T10:00:00Z');

  final tModel = NotificationModel(
    id: 1,
    title: 'Order update',
    body: 'Your order has shipped',
    type: 'ORDER',
    data: const {ApiKeys.id: 99},
    createdAt: tCreatedAt,
    isRead: true,
  );

  final tJson = {
    ApiKeys.id: 1,
    ApiKeys.title: 'Order update',
    ApiKeys.body: 'Your order has shipped',
    ApiKeys.type: 'ORDER',
    ApiKeys.data: {ApiKeys.id: 99},
    ApiKeys.createdAt: '2026-05-20T10:00:00.000Z',
    ApiKeys.isRead: 1,
  };

  group('NotificationModel', () {
    test('maps from JSON correctly', () {
      final result = NotificationModel.fromJson(tJson);

      expect(result.id, tModel.id);
      expect(result.title, tModel.title);
      expect(result.body, tModel.body);
      expect(result.type, tModel.type);
      expect(result.data, tModel.data);
      expect(result.createdAt, tModel.createdAt);
      expect(result.isRead, tModel.isRead);
    });

    test('maps from JSON with id and isRead as strings', () {
      final json = Map<String, dynamic>.from(tJson)
        ..[ApiKeys.id] = '1'
        ..[ApiKeys.isRead] = '1';

      final result = NotificationModel.fromJson(json);

      expect(result.id, 1);
      expect(result.isRead, isTrue);
    });

    test('defaults optional string fields when missing', () {
      final json = {
        ApiKeys.id: 1,
        ApiKeys.createdAt: '2026-05-20T10:00:00.000Z',
        ApiKeys.isRead: 0,
      };

      final result = NotificationModel.fromJson(json);

      expect(result.title, '');
      expect(result.body, '');
      expect(result.type, '');
      expect(result.data, isEmpty);
      expect(result.isRead, isFalse);
    });

    test('defaults data to empty map when data is not a map', () {
      final json = Map<String, dynamic>.from(tJson)..[ApiKeys.data] = 'invalid';

      final result = NotificationModel.fromJson(json);

      expect(result.data, isEmpty);
    });

    test('defaults isRead to false when value is invalid', () {
      final json = Map<String, dynamic>.from(tJson)..[ApiKeys.isRead] = 'invalid';

      final result = NotificationModel.fromJson(json);

      expect(result.isRead, isFalse);
    });

    test('uses DateTime.now fallback when createdAt is invalid', () {
      final before = DateTime.now();
      final json = Map<String, dynamic>.from(tJson)
        ..[ApiKeys.createdAt] = 'invalid-date';

      final result = NotificationModel.fromJson(json);
      final after = DateTime.now();

      expect(result.createdAt.isAfter(before) || result.createdAt.isAtSameMomentAs(before), isTrue);
      expect(result.createdAt.isBefore(after) || result.createdAt.isAtSameMomentAs(after), isTrue);
    });

    test('maps to JSON correctly', () {
      final result = tModel.toJson();

      expect(result, tJson);
    });

    test('maps to NotificationEntity correctly', () {
      final result = tModel.toEntity();

      expect(result, isA<NotificationEntity>());
      expect(result.id, tModel.id);
      expect(result.title, tModel.title);
      expect(result.body, tModel.body);
      expect(result.type, tModel.type);
      expect(result.data, tModel.data);
      expect(result.createdAt, tModel.createdAt);
      expect(result.isRead, tModel.isRead);
    });

    test('throws FormatException when id is not parseable', () {
      final json = Map<String, dynamic>.from(tJson)..[ApiKeys.id] = 'invalid';

      expect(() => NotificationModel.fromJson(json), throwsA(isA<FormatException>()));
    });
  });
}

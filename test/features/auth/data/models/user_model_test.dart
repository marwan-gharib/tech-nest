import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/auth/data/models/user_model.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';

void main() {
  const tId = 42;
  const tName = 'Alice Smith';
  const tEmail = 'alice@example.com';
  const tImage = 'https://cdn.example.com/alice.png';

  final tUserModelWithImage = UserModel(
    id: tId,
    name: tName,
    email: tEmail,
    image: tImage,
  );

  final tUserModelNoImage = UserModel(id: tId, name: tName, email: tEmail);

  group('UserModel', () {
    group('fromJson', () {
      test('should create a valid UserModel from a complete JSON map', () {
        final json = {
          ApiKeys.id: tId,
          ApiKeys.name: tName,
          ApiKeys.email: tEmail,
          ApiKeys.image: tImage,
        };

        final result = UserModel.fromJson(json);

        expect(result.id, tId);
        expect(result.name, tName);
        expect(result.email, tEmail);
        expect(result.image, tImage);
      });

      test('should fall back to profileImgUrl when image key is absent', () {
        const profileUrl = 'https://cdn.example.com/profile.png';
        final json = {
          ApiKeys.id: tId,
          ApiKeys.name: tName,
          ApiKeys.email: tEmail,
          ApiKeys.profileImgUrl: profileUrl,
        };

        final result = UserModel.fromJson(json);

        expect(result.image, profileUrl);
      });

      test(
        'should fall back to imgUrl when image and profileImgUrl keys are absent',
        () {
          const imgUrl = 'https://cdn.example.com/img.png';
          final json = {
            ApiKeys.id: tId,
            ApiKeys.name: tName,
            ApiKeys.email: tEmail,
            ApiKeys.imgUrl: imgUrl,
          };

          final result = UserModel.fromJson(json);

          expect(result.image, imgUrl);
        },
      );

      test(
        'should set image to null when none of the image keys are present',
        () {
          final json = {
            ApiKeys.id: tId,
            ApiKeys.name: tName,
            ApiKeys.email: tEmail,
          };

          final result = UserModel.fromJson(json);

          expect(result.image, isNull);
        },
      );

      test('should parse id when provided as a String', () {
        final json = {
          ApiKeys.id: '$tId', // API returns id as string in some responses
          ApiKeys.name: tName,
          ApiKeys.email: tEmail,
        };

        final result = UserModel.fromJson(json);

        expect(result.id, tId);
      });

      test(
        'should default name and email to empty string when null in JSON',
        () {
          final json = {
            ApiKeys.id: tId,
            ApiKeys.name: null,
            ApiKeys.email: null,
          };

          final result = UserModel.fromJson(json);

          expect(result.name, '');
          expect(result.email, '');
        },
      );
    });

    group('toJson', () {
      test(
        'should return a valid JSON map with all fields when image is present',
        () {
          final result = tUserModelWithImage.toJson();

          expect(result[ApiKeys.id], tId);
          expect(result[ApiKeys.name], tName);
          expect(result[ApiKeys.email], tEmail);
          expect(result[ApiKeys.image], tImage);
        },
      );

      test(
        'should return image as null in JSON when image field is absent',
        () {
          final result = tUserModelNoImage.toJson();

          expect(result[ApiKeys.image], isNull);
        },
      );
    });

    group('toEntity', () {
      test(
        'should convert UserModel to UserEntity with identical field values',
        () {
          final entity = tUserModelWithImage.toEntity();

          expect(entity, isA<UserEntity>());
          expect(entity.id, tUserModelWithImage.id);
          expect(entity.name, tUserModelWithImage.name);
          expect(entity.email, tUserModelWithImage.email);
          expect(entity.image, tUserModelWithImage.image);
        },
      );
    });
  });
}

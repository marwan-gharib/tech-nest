import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/cache_failure.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:tech_nest/features/auth/data/models/user_model.dart';

class MockCacheService extends Mock implements CacheService {}

void main() {
  late UserLocalDataSourceImpl datasource;
  late MockCacheService mockCacheService;

  setUp(() {
    mockCacheService = MockCacheService();
    datasource = UserLocalDataSourceImpl(mockCacheService);
  });

  setUpAll(() {
    registerFallbackValue('');
  });

  final tUserModel = UserModel(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    image: null,
  );

  final tUserJson = jsonEncode(tUserModel.toJson());

  group('saveUser', () {
    test(
      'should call CacheService.setData with the encoded user JSON',
      () async {
        when(
          () => mockCacheService.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        await datasource.saveUser(tUserModel);

        verify(
          () => mockCacheService.setData(
            key: 'user',
            value: any(named: 'value'),
          ),
        ).called(1);
      },
    );
  });

  group('getUser', () {
    test(
      'should return Right(UserModel) when cache contains a valid user JSON',
      () {
        when(() => mockCacheService.get(any())).thenReturn(tUserJson);

        final result = datasource.getUser();

        expect(result.isRight(), true);
        result.fold((_) => fail('Expected Right'), (user) {
          expect(user, isA<UserModel>());
          expect(user!.id, 1);
          expect(user.name, 'John Doe');
        });
      },
    );

    test('should return Right(null) when cache has no stored user', () {
      when(() => mockCacheService.get(any())).thenReturn(null);

      final result = datasource.getUser();

      expect(result, equals(const Right(null)));
    });

    test(
      'should return Left(CacheFailure) when cache throws a generic exception',
      () {
        when(
          () => mockCacheService.get(any()),
        ).thenThrow(Exception('Cache read error'));

        final result = datasource.getUser();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );
  });

  group('clearUser', () {
    test('should call CacheService.remove with the user key', () async {
      when(() => mockCacheService.remove(any())).thenAnswer((_) async => true);

      await datasource.clearUser();

      verify(() => mockCacheService.remove('user')).called(1);
    });
  });
}

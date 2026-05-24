import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/features/auth/data/datasources/local/auth_local_data_source.dart';

class MockSecureStorageClient extends Mock implements SecureStorageClient {}

void main() {
  late AuthLocalDatasource datasource;
  late MockSecureStorageClient mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockSecureStorageClient();
    datasource = AuthLocalDatasource(mockSecureStorage);
  });

  group('saveToken', () {
    const tToken = 'abc123token';

    test(
      'should call SecureStorageClient.saveToken with the correct token',
      () async {
        when(() => mockSecureStorage.saveToken(any())).thenAnswer((_) async {});

        await datasource.saveToken(tToken);

        verify(() => mockSecureStorage.saveToken(tToken)).called(1);
      },
    );

    test(
      'should throw UnKnownException when SecureStorageClient throws',
      () async {
        when(
          () => mockSecureStorage.saveToken(any()),
        ).thenThrow(Exception('Storage error'));

        expect(
          () => datasource.saveToken(tToken),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('getToken', () {
    const tToken = 'abc123token';

    test(
      'should return token string when SecureStorageClient has a token',
      () async {
        when(
          () => mockSecureStorage.getToken(),
        ).thenAnswer((_) async => tToken);

        final result = await datasource.getToken();

        expect(result, tToken);
        verify(() => mockSecureStorage.getToken()).called(1);
      },
    );

    test('should return null when SecureStorageClient has no token', () async {
      when(() => mockSecureStorage.getToken()).thenAnswer((_) async => null);

      final result = await datasource.getToken();

      expect(result, isNull);
    });

    test(
      'should throw UnKnownException when SecureStorageClient throws',
      () async {
        when(
          () => mockSecureStorage.getToken(),
        ).thenThrow(Exception('Storage error'));

        expect(() => datasource.getToken(), throwsA(isA<UnKnownException>()));
      },
    );
  });

  group('clearCache', () {
    test('should call SecureStorageClient.deleteToken', () async {
      when(() => mockSecureStorage.deleteToken()).thenAnswer((_) async {});

      await datasource.clearCache();

      verify(() => mockSecureStorage.deleteToken()).called(1);
    });

    test(
      'should throw UnKnownException when SecureStorageClient throws',
      () async {
        when(
          () => mockSecureStorage.deleteToken(),
        ).thenThrow(Exception('Storage error'));

        expect(() => datasource.clearCache(), throwsA(isA<UnKnownException>()));
      },
    );
  });
}

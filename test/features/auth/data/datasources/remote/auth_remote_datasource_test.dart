import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/data/models/auth_model.dart';
import 'package:tech_nest/features/auth/data/models/user_model.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AuthRemoteDatasource datasource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = AuthRemoteDatasource(mockApiClient);
  });

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  // Helper responses
  const tUserJson = {
    'id': 1,
    'name': 'John Doe',
    'email': 'john@example.com',
    'image': null,
  };

  final tAuthResponse = {
    'status': 200,
    'data': {'token': 'abc123', 'user': tUserJson},
  };

  final tNoDataResponse = {'status': 200, 'data': null};

  final tErrorResponse = {'status': 400, 'message': 'Invalid credentials'};

  group('login', () {
    final tParams = LoginParams(
      email: 'john@example.com',
      password: 'Password1!',
    );

    test('should return AuthModel when response is valid', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => tAuthResponse);

      final result = await datasource.login(params: tParams);

      expect(result, isA<AuthModel>());
      expect(result.token, 'abc123');
      expect(result.userModel, isA<UserModel>());
    });

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.login(params: tParams),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'should throw ServerException when response status is not 2xx',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => tErrorResponse);

        expect(
          () => datasource.login(params: tParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when data inside response is null',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => tNoDataResponse);

        expect(
          () => datasource.login(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.login(params: tParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.login(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('verifyEmail', () {
    final tParams = VerificationEmailParams(
      email: 'john@example.com',
      code: '123456',
    );

    test('should return AuthModel when response is valid', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => tAuthResponse);

      final result = await datasource.verifyEmail(params: tParams);

      expect(result, isA<AuthModel>());
      expect(result.token, 'abc123');
    });

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.verifyEmail(params: tParams),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'should throw ServerException when response status is not 2xx',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => tErrorResponse);

        expect(
          () => datasource.verifyEmail(params: tParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when data inside response is null',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => tNoDataResponse);

        expect(
          () => datasource.verifyEmail(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.verifyEmail(params: tParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.verifyEmail(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('resetPassword', () {
    final tParams = ResetPasswordParams(
      email: 'john@example.com',
      code: '123456',
      newPass: 'NewPassword1!',
    );

    final tSuccessResponse = {'status': 200, 'message': 'Password reset'};

    test('should complete without error when response is valid', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => tSuccessResponse);

      await expectLater(datasource.resetPassword(params: tParams), completes);
    });

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.resetPassword(params: tParams),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'should throw ServerException when response status is not 2xx',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => tErrorResponse);

        expect(
          () => datasource.resetPassword(params: tParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.resetPassword(params: tParams),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.resetPassword(params: tParams),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('forgetPassword', () {
    const tEmail = 'john@example.com';

    final tSuccessResponse = {'status': 200, 'message': 'Email sent'};

    test('should complete without error when response is valid', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => tSuccessResponse);

      await expectLater(datasource.forgetPassword(email: tEmail), completes);
    });

    test('should throw UnKnownException when response is null', () async {
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.forgetPassword(email: tEmail),
        throwsA(isA<UnKnownException>()),
      );
    });

    test(
      'should throw ServerException when response status is not 2xx',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => tErrorResponse);

        expect(
          () => datasource.forgetPassword(email: tEmail),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(ServerException('Server error'));

        expect(
          () => datasource.forgetPassword(email: tEmail),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            extra: any(named: 'extra'),
          ),
        ).thenThrow(Exception('Unexpected'));

        expect(
          () => datasource.forgetPassword(email: tEmail),
          throwsA(isA<UnKnownException>()),
        );
      },
    );
  });

  group('logout', () {
    test('should complete without error when API call succeeds', () async {
      when(() => mockApiClient.post(any())).thenAnswer((_) async => null);

      await expectLater(datasource.logout(), completes);

      verify(() => mockApiClient.post(any())).called(1);
    });

    test(
      'should rethrow AppException when API throws an AppException',
      () async {
        when(
          () => mockApiClient.post(any()),
        ).thenThrow(ServerException('Unauthorized'));

        expect(() => datasource.logout(), throwsA(isA<ServerException>()));
      },
    );

    test(
      'should throw UnKnownException when API throws a generic exception',
      () async {
        when(
          () => mockApiClient.post(any()),
        ).thenThrow(Exception('Unexpected'));

        expect(() => datasource.logout(), throwsA(isA<UnKnownException>()));
      },
    );
  });
}

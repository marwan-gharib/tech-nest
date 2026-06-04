import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:tech_nest/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:tech_nest/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:tech_nest/features/auth/data/models/auth_model.dart';
import 'package:tech_nest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

AuthModel _buildAuthModel({
  String token = 'test-token',
  int id = 1,
  String name = 'John Doe',
  String email = 'john@example.com',
}) {
  return AuthModel.fromJson({
    ApiKeys.token: token,
    ApiKeys.user: {ApiKeys.id: id, ApiKeys.name: name, ApiKeys.email: email},
  });
}

void main() {
  late MockAuthRemoteDatasource mockRemote;
  late MockAuthLocalDatasource mockLocal;
  late MockUserLocalDataSource mockUserLocal;
  late AuthRepositoryImpl sut;

  final tLoginParams = LoginParams(
    email: 'john@example.com',
    password: 'Password1',
  );
  final tAuthModel = _buildAuthModel();
  final tUserModel = tAuthModel.userModel;
  final tUserEntity = tUserModel.toEntity();

  final tSignUpParams = SignUpParams(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'Password1',
    img: File('path/image.jpg'),
  );

  final tVerifyParams = VerificationEmailParams(
    email: 'john@example.com',
    code: '123456',
  );

  final tResetParams = ResetPasswordParams(
    email: 'john@example.com',
    code: '654321',
    newPass: 'NewPassword1',
  );

  setUpAll(() {
    registerFallbackValue(tLoginParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tVerifyParams);
    registerFallbackValue(tResetParams);
    registerFallbackValue(tUserModel);
  });

  setUp(() {
    mockRemote = MockAuthRemoteDatasource();
    mockLocal = MockAuthLocalDatasource();
    mockUserLocal = MockUserLocalDataSource();
    sut = AuthRepositoryImpl(mockRemote, mockLocal, mockUserLocal);
  });

  group('login', () {
    test(
      'should save token and user, then return ApiSuccess(UserEntity) on success',
      () async {
        when(
          () => mockRemote.login(params: any(named: 'params')),
        ).thenAnswer((_) async => tAuthModel);
        when(() => mockLocal.saveToken(any())).thenAnswer((_) async {});
        when(() => mockUserLocal.saveUser(any())).thenAnswer((_) async {});

        final result = await sut.login(params: tLoginParams);

        expect(result, isA<ApiSuccess>());
        result.fold((_) => fail('Expected Right but got Left'), (user) {
          expect(user.id, tUserEntity.id);
          expect(user.email, tUserEntity.email);
        });
        verify(() => mockLocal.saveToken(tAuthModel.token)).called(1);
        verify(() => mockUserLocal.saveUser(any())).called(1);
      },
    );

    test(
      'should return ApiFailure(ServerFailure) when a ServerException is thrown',
      () async {
        when(
          () => mockRemote.login(params: any(named: 'params')),
        ).thenThrow(ServerException('Invalid credentials', activeToUser: true));

        final result = await sut.login(params: tLoginParams);

        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Invalid credentials');
        }, (_) => fail('Expected Left but got Right'));
        verifyNever(() => mockLocal.saveToken(any()));
        verifyNever(() => mockUserLocal.saveUser(any()));
      },
    );

    test(
      'should return ApiFailure(NetworkFailure) when a NetworkException is thrown',
      () async {
        when(
          () => mockRemote.login(params: any(named: 'params')),
        ).thenThrow(NetworkException('No connection'));

        final result = await sut.login(params: tLoginParams);

        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
      },
    );

    test('should return ApiFailure(UnknownFailure) on unhandled exception', () async {
      when(
        () => mockRemote.login(params: any(named: 'params')),
      ).thenThrow(Exception('Something wild happened'));

      final result = await sut.login(params: tLoginParams);

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('signUp', () {
    test(
      'should save user locally and return ApiSuccess(UserEntity) on success',
      () async {
        when(
          () => mockRemote.signUp(params: any(named: 'params')),
        ).thenAnswer((_) async => tUserModel);
        when(() => mockUserLocal.saveUser(any())).thenAnswer((_) async {});

        final result = await sut.signUp(params: tSignUpParams);

        expect(result, isA<ApiSuccess>());
        verify(() => mockUserLocal.saveUser(any())).called(1);
        verifyNever(() => mockLocal.saveToken(any()));
      },
    );

    test('should return ApiFailure(ServerFailure) on ServerException', () async {
      when(
        () => mockRemote.signUp(params: any(named: 'params')),
      ).thenThrow(ServerException('Email already in use', activeToUser: true));

      final result = await sut.signUp(params: tSignUpParams);

      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Email already in use');
      }, (_) => fail('Expected Left but got Right'));
    });

    test('should return ApiFailure(UnknownFailure) on unhandled exception', () async {
      when(
        () => mockRemote.signUp(params: any(named: 'params')),
      ).thenThrow(Exception());

      final result = await sut.signUp(params: tSignUpParams);

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('logout', () {
    test(
      'should call remote logout, clear token, clear user, and return Right',
      () async {
        when(() => mockRemote.logout()).thenAnswer((_) async {});
        when(() => mockLocal.clearCache()).thenAnswer((_) async {});
        when(() => mockUserLocal.clearUser()).thenAnswer((_) async {});

        final result = await sut.logout();

        expect(result, isA<ApiSuccess>());
        verify(() => mockRemote.logout()).called(1);
        verify(() => mockLocal.clearCache()).called(1);
        verify(() => mockUserLocal.clearUser()).called(1);
      },
    );

    test(
      'should return ApiFailure(ServerFailure) when remote logout throws',
      () async {
        when(
          () => mockRemote.logout(),
        ).thenThrow(ServerException('Logout failed', activeToUser: true));

        final result = await sut.logout();

        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
        verifyNever(() => mockLocal.clearCache());
        verifyNever(() => mockUserLocal.clearUser());
      },
    );
  });

  group('verifyEmail', () {
    test(
      'should save token and user, then return ApiSuccess(UserEntity) on success',
      () async {
        when(
          () => mockRemote.verifyEmail(params: any(named: 'params')),
        ).thenAnswer((_) async => tAuthModel);
        when(() => mockLocal.saveToken(any())).thenAnswer((_) async {});
        when(() => mockUserLocal.saveUser(any())).thenAnswer((_) async {});

        final result = await sut.verifyEmail(params: tVerifyParams);

        expect(result, isA<ApiSuccess>());
        verify(() => mockLocal.saveToken(tAuthModel.token)).called(1);
        verify(() => mockUserLocal.saveUser(any())).called(1);
      },
    );

    test('should return ApiFailure(ServerFailure) on invalid OTP', () async {
      when(
        () => mockRemote.verifyEmail(params: any(named: 'params')),
      ).thenThrow(ServerException('Invalid code', activeToUser: true));

      final result = await sut.verifyEmail(params: tVerifyParams);

      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Invalid code');
      }, (_) => fail('Expected Left but got Right'));
    });
  });

  group('forgetPassword', () {
    test(
      'should return ApiSuccess(void) when forget-password call succeeds',
      () async {
        when(
          () => mockRemote.forgetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async {});

        final result = await sut.forgetPassword(email: 'john@example.com');

        expect(result, isA<ApiSuccess>());
        verify(
          () => mockRemote.forgetPassword(email: 'john@example.com'),
        ).called(1);
      },
    );

    test('should return ApiFailure(ServerFailure) on ServerException', () async {
      when(
        () => mockRemote.forgetPassword(email: any(named: 'email')),
      ).thenThrow(ServerException('Email not found', activeToUser: true));

      final result = await sut.forgetPassword(email: 'unknown@example.com');

      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Email not found');
      }, (_) => fail('Expected Left but got Right'));
    });
  });

  group('resetPassword', () {
    test('should return ApiSuccess(void) on successful password reset', () async {
      when(
        () => mockRemote.resetPassword(params: any(named: 'params')),
      ).thenAnswer((_) async {});

      final result = await sut.resetPassword(params: tResetParams);

      expect(result, isA<ApiSuccess>());
      verify(
        () => mockRemote.resetPassword(params: any(named: 'params')),
      ).called(1);
    });

    test('should return ApiFailure(ServerFailure) when code has expired', () async {
      when(
        () => mockRemote.resetPassword(params: any(named: 'params')),
      ).thenThrow(ServerException('Code expired', activeToUser: true));

      final result = await sut.resetPassword(params: tResetParams);

      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Code expired');
      }, (_) => fail('Expected Left but got Right'));
    });
  });

  group('getCachedUser', () {
    test('should return ApiSuccess(UserEntity) when a cached user exists', () {
      when(() => mockUserLocal.getUser()).thenReturn(ApiSuccess(tUserModel));

      final result = sut.getCachedUser();

      expect(result, isA<ApiSuccess>());
      result.fold((_) => fail('Expected Right'), (user) {
        expect(user, isA<UserEntity>());
        expect(user!.id, tUserModel.id);
      });
    });

    test('should return ApiSuccess(null) when cache is empty', () {
      when(() => mockUserLocal.getUser()).thenReturn(const ApiSuccess(null));

      final result = sut.getCachedUser();

      expect(result, const ApiSuccess(null));
    });

    test('should return ApiFailure(UnknownFailure) when an exception is thrown', () {
      when(
        () => mockUserLocal.getUser(),
      ).thenThrow(Exception('cache corrupted'));

      final result = sut.getCachedUser();

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

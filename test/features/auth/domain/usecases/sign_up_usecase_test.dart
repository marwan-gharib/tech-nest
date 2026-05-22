import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late SignUpUsecase sut;

  final tFile = File('path/to/image.jpg');
  final tParams = SignUpParams(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'Password1',
    img: tFile,
  );
  final tUser = UserEntity(id: 2, name: 'John Doe', email: 'john@example.com');

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = SignUpUsecase(mockRepo);
  });

  group('SignUpUsecase', () {
    test('should return Right(UserEntity) when sign-up succeeds', () async {
      when(
        () => mockRepo.signUp(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));

      final result = await sut.call(params: tParams);

      expect(result, Right(tUser));
      verify(() => mockRepo.signUp(params: tParams)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return Left(ServerFailure) on server error', () async {
      final tFailure = ServerFailure();
      when(
        () => mockRepo.signUp(params: any(named: 'params')),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await sut.call(params: tParams);

      expect(result, Left(tFailure));
      verify(() => mockRepo.signUp(params: tParams)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
      'should return Left(NetworkFailure) when there is no internet',
      () async {
        final tFailure = NetworkFailure();
        when(
          () => mockRepo.signUp(params: any(named: 'params')),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call(params: tParams);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
      },
    );

    test('should forward the exact SignUpParams to the repository', () async {
      when(
        () => mockRepo.signUp(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));

      await sut.call(params: tParams);

      final captured = verify(
        () => mockRepo.signUp(params: captureAny(named: 'params')),
      ).captured;
      final capturedParams = captured.first as SignUpParams;
      expect(capturedParams.name, tParams.name);
      expect(capturedParams.email, tParams.email);
      expect(capturedParams.password, tParams.password);
    });
  });
}

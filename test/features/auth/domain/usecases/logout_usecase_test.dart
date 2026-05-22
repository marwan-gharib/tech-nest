import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late LogoutUsecase sut;

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = LogoutUsecase(mockRepo);
  });

  group('LogoutUsecase', () {
    test('should return Right(void) when logout succeeds', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async => const Right(null));

      final result = await sut.call();

      expect(result.isRight(), true);
      verify(() => mockRepo.logout()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
      'should return Left(ServerFailure) when server returns an error',
      () async {
        final tFailure = ServerFailure();
        when(() => mockRepo.logout()).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call();

        expect(result, Left(tFailure));
        verify(() => mockRepo.logout()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return Left(NetworkFailure) when network is unavailable',
      () async {
        final tFailure = NetworkFailure();
        when(() => mockRepo.logout()).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call();

        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
      },
    );

    test(
      'should return Left(UnknownFailure) when an unexpected error occurs',
      () async {
        final tFailure = UnknownFailure();
        when(() => mockRepo.logout()).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call();

        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
      },
    );

    test('should call repository logout exactly once per call', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async => const Right(null));

      await sut.call();
      await sut.call();

      verify(() => mockRepo.logout()).called(2);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/forget_password_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late ForgetPasswordUsecase sut;

  const tEmail = 'test@example.com';
  const tInvalidEmail = 'not-an-email';

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = ForgetPasswordUsecase(mockRepo);
  });

  group('ForgetPasswordUsecase', () {
    test(
      'should return Right(void) when forget-password request succeeds',
      () async {
        when(
          () => mockRepo.forgetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        final result = await sut.call(email: tEmail);

        expect(result.isRight(), true);
        verify(() => mockRepo.forgetPassword(email: tEmail)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return Left(ServerFailure) when the server rejects the request',
      () async {
        final tFailure = ServerFailure(message: 'Email not found');
        when(
          () => mockRepo.forgetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call(email: tEmail);

        expect(result, Left(tFailure));
        verify(() => mockRepo.forgetPassword(email: tEmail)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('should return Left(NetworkFailure) when device is offline', () async {
      final tFailure = NetworkFailure();
      when(
        () => mockRepo.forgetPassword(email: any(named: 'email')),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await sut.call(email: tEmail);

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should forward the exact email string to the repository', () async {
      when(
        () => mockRepo.forgetPassword(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(null));

      await sut.call(email: tEmail);

      final captured = verify(
        () => mockRepo.forgetPassword(email: captureAny(named: 'email')),
      ).captured;
      expect(captured.first, tEmail);
    });

    test(
      'should forward the invalid email string as-is (validation is UI concern)',
      () async {
        when(
          () => mockRepo.forgetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(null));

        final result = await sut.call(email: tInvalidEmail);

        expect(result.isRight(), true);
        verify(() => mockRepo.forgetPassword(email: tInvalidEmail)).called(1);
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/verification_email_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/verify_email_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late VerifyEmailUsecase sut;

  final tParams = VerificationEmailParams(
    email: 'test@example.com',
    code: '123456',
  );
  final tUser = UserEntity(id: 1, name: 'John Doe', email: 'test@example.com');
  final tFailure = ServerFailure(message: 'Invalid code');

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = VerifyEmailUsecase(mockRepo);
  });

  group('VerifyEmailUsecase', () {
    test(
      'should return Right(UserEntity) when email verification succeeds',
      () async {
        when(
          () => mockRepo.verifyEmail(params: any(named: 'params')),
        ).thenAnswer((_) async => Right(tUser));

        final result = await sut.call(params: tParams);

        expect(result, Right(tUser));
        verify(() => mockRepo.verifyEmail(params: tParams)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return Left(ServerFailure) when OTP code is invalid',
      () async {
        when(
          () => mockRepo.verifyEmail(params: any(named: 'params')),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call(params: tParams);

        expect(result, Left(tFailure));
        verify(() => mockRepo.verifyEmail(params: tParams)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('should forward email and code to the repository unchanged', () async {
      when(
        () => mockRepo.verifyEmail(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));

      await sut.call(params: tParams);

      final captured = verify(
        () => mockRepo.verifyEmail(params: captureAny(named: 'params')),
      ).captured;
      final capturedParams = captured.first as VerificationEmailParams;
      expect(capturedParams.email, tParams.email);
      expect(capturedParams.code, tParams.code);
    });
  });
}

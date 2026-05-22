import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/reset_password_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late ResetPasswordUsecase sut;

  final tParams = ResetPasswordParams(
    email: 'test@example.com',
    code: '654321',
    newPass: 'NewPassword1',
  );

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = ResetPasswordUsecase(mockRepo);
  });

  group('ResetPasswordUsecase', () {
    test(
      'should return Right(void) when password is reset successfully',
      () async {
        when(
          () => mockRepo.resetPassword(params: any(named: 'params')),
        ).thenAnswer((_) async => const Right(null));

        final result = await sut.call(params: tParams);

        expect(result.isRight(), true);
        verify(() => mockRepo.resetPassword(params: tParams)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return Left(ServerFailure) when the reset code is invalid',
      () async {
        final tFailure = ServerFailure(message: 'Invalid or expired code');
        when(
          () => mockRepo.resetPassword(params: any(named: 'params')),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call(params: tParams);

        expect(result, Left(tFailure));
        result.fold(
          (f) => expect(f.message, 'Invalid or expired code'),
          (_) => fail('Expected Left but got Right'),
        );
      },
    );

    test(
      'should forward email, code and newPass to the repository unchanged',
      () async {
        when(
          () => mockRepo.resetPassword(params: any(named: 'params')),
        ).thenAnswer((_) async => const Right(null));

        await sut.call(params: tParams);

        final captured = verify(
          () => mockRepo.resetPassword(params: captureAny(named: 'params')),
        ).captured;
        final capturedParams = captured.first as ResetPasswordParams;
        expect(capturedParams.email, tParams.email);
        expect(capturedParams.code, tParams.code);
        expect(capturedParams.newPass, tParams.newPass);
      },
    );
  });
}

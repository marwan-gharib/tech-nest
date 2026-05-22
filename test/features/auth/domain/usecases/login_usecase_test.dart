import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late LoginUsecase sut;

  final tParams = LoginParams(email: 'test@example.com', password: 'Password1');
  final tUser = UserEntity(id: 1, name: 'John Doe', email: 'test@example.com');
  final tFailure = ServerFailure();

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = LoginUsecase(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(LoginParams(email: '', password: ''));
  });

  group('LoginUsecase', () {
    test(
      'should return Right(UserEntity) when the repository call succeeds',
      () async {
        when(
          () => mockRepo.login(params: any(named: 'params')),
        ).thenAnswer((_) async => Right(tUser));

        final result = await sut.call(params: tParams);

        expect(result, Right(tUser));
        verify(() => mockRepo.login(params: tParams)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return Left(Failure) when the repository call fails',
      () async {
        when(
          () => mockRepo.login(params: any(named: 'params')),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await sut.call(params: tParams);

        expect(result, Left(tFailure));
        verify(() => mockRepo.login(params: tParams)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('should forward the exact LoginParams to the repository', () async {
      when(
        () => mockRepo.login(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));

      await sut.call(params: tParams);

      final captured = verify(
        () => mockRepo.login(params: captureAny(named: 'params')),
      ).captured;
      final capturedParams = captured.first as LoginParams;
      expect(capturedParams.email, tParams.email);
      expect(capturedParams.password, tParams.password);
    });
  });
}

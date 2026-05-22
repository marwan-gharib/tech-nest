import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/cache_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_nest/features/auth/domain/usecases/get_cached_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late GetCachedUserUseCase sut;

  final tUser = UserEntity(id: 1, name: 'Jane Doe', email: 'jane@example.com');

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = GetCachedUserUseCase(mockRepo);
  });

  group('GetCachedUserUseCase', () {
    test('should return Right(UserEntity) when a cached user exists', () {
      when(() => mockRepo.getCachedUser()).thenReturn(Right(tUser));

      final result = sut.call();

      expect(result, Right(tUser));
      verify(() => mockRepo.getCachedUser()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return Right(null) when cache is empty', () {
      when(() => mockRepo.getCachedUser()).thenReturn(const Right(null));

      final result = sut.call();

      expect(result, const Right(null));
      verify(() => mockRepo.getCachedUser()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return Left(CacheFailure) when reading the cache fails', () {
      final tFailure = CacheFailure();
      when(() => mockRepo.getCachedUser()).thenReturn(Left(tFailure));

      final result = sut.call();

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left(UnknownFailure) on unexpected errors', () {
      final tFailure = UnknownFailure();
      when(() => mockRepo.getCachedUser()).thenReturn(Left(tFailure));

      final result = sut.call();

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should be synchronous — no async/await required', () {
      when(() => mockRepo.getCachedUser()).thenReturn(Right(tUser));

      final result = sut.call();
      expect(result, isA<Either<dynamic, UserEntity?>>());
    });
  });
}

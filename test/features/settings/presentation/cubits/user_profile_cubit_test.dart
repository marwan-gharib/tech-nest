import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_state.dart';

class MockGetCachedUserUseCase extends Mock implements GetCachedUserUseCase {}

void main() {
  late MockGetCachedUserUseCase mockGetCachedUserUseCase;

  final user = UserEntity(id: 1, name: 'John', email: 'john@example.com');
  final failure = ServerFailure(message: 'failed');

  setUp(() {
    mockGetCachedUserUseCase = MockGetCachedUserUseCase();
  });

  blocTest<UserProfileCubit, UserProfileState>(
    'emits loading then loaded when cached user exists',
    build: () {
      when(() => mockGetCachedUserUseCase.call()).thenReturn(Right(user));
      return UserProfileCubit(mockGetCachedUserUseCase);
    },
    act: (cubit) => cubit.loadUser(),
    expect: () => [
      const UserProfileLoading(),
      isA<UserProfileLoaded>().having((state) => state.user, 'user', user),
    ],
    verify: (_) {
      verify(() => mockGetCachedUserUseCase.call()).called(2);
    },
  );

  blocTest<UserProfileCubit, UserProfileState>(
    'emits loading then empty when cached user is null',
    build: () {
      when(() => mockGetCachedUserUseCase.call()).thenReturn(const Right(null));
      return UserProfileCubit(mockGetCachedUserUseCase);
    },
    act: (cubit) => cubit.loadUser(),
    expect: () => [const UserProfileLoading(), const UserProfileEmpty()],
  );

  blocTest<UserProfileCubit, UserProfileState>(
    'emits loading then error when getting cached user fails',
    build: () {
      when(() => mockGetCachedUserUseCase.call()).thenReturn(Left(failure));
      return UserProfileCubit(mockGetCachedUserUseCase);
    },
    act: (cubit) => cubit.loadUser(),
    expect: () => [
      const UserProfileLoading(),
      const UserProfileError('Failed to load user profile'),
    ],
  );

  blocTest<UserProfileCubit, UserProfileState>(
    'loads user every time loadUser is called',
    build: () {
      when(() => mockGetCachedUserUseCase.call()).thenReturn(Right(user));
      return UserProfileCubit(mockGetCachedUserUseCase);
    },
    act: (cubit) => cubit.loadUser(),
    expect: () => [
      const UserProfileLoading(),
      isA<UserProfileLoaded>().having((state) => state.user, 'user', user),
    ],
    verify: (_) {
      verify(() => mockGetCachedUserUseCase.call()).called(2);
    },
  );

  test('constructor triggers loadUser immediately', () {
    when(() => mockGetCachedUserUseCase.call()).thenReturn(const Right(null));

    UserProfileCubit(mockGetCachedUserUseCase);

    verify(() => mockGetCachedUserUseCase.call()).called(1);
  });
}

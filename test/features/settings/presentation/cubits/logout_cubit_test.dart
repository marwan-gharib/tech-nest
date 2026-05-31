import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockLogoutUsecase mockLogoutUsecase;
  late LogoutCubit cubit;

  final failure = ServerFailure(message: 'logout failed');

  setUp(() {
    mockLogoutUsecase = MockLogoutUsecase();
    cubit = LogoutCubit(mockLogoutUsecase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is LogoutInitial', () {
    expect(cubit.state, const LogoutInitial());
  });

  blocTest<LogoutCubit, LogoutState>(
    'emits loading then success when logout succeeds',
    build: () {
      when(
        () => mockLogoutUsecase.call(),
      ).thenAnswer((_) async => const Right(null));
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [const LogoutLoading(), const LogoutSuccess()],
    verify: (_) {
      verify(() => mockLogoutUsecase.call()).called(1);
    },
  );

  blocTest<LogoutCubit, LogoutState>(
    'emits loading then failure when logout fails',
    build: () {
      when(
        () => mockLogoutUsecase.call(),
      ).thenAnswer((_) async => Left(failure));
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [const LogoutLoading(), LogoutFailure(failure)],
  );

  blocTest<LogoutCubit, LogoutState>(
    'keeps state consistency after repeated calls',
    build: () {
      when(
        () => mockLogoutUsecase.call(),
      ).thenAnswer((_) async => const Right(null));
      return cubit;
    },
    act: (cubit) async {
      await cubit.logout();
      await cubit.logout();
    },
    expect: () => [
      const LogoutLoading(),
      const LogoutSuccess(),
      const LogoutLoading(),
      const LogoutSuccess(),
    ],
    verify: (_) {
      verify(() => mockLogoutUsecase.call()).called(2);
    },
  );

  test('rethrows unexpected exception', () async {
    when(() => mockLogoutUsecase.call()).thenThrow(Exception('unexpected'));

    await expectLater(cubit.logout(), throwsException);
    expect(cubit.state, const LogoutLoading());
  });
}

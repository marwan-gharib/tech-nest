import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/login_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_nest/features/auth/presentation/cubits/login_cubit/login_cubit.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  late MockLoginUsecase mockUsecase;

  const tEmail = 'test@example.com';
  const tPassword = 'Password1';
  final tUser = UserEntity(id: 1, name: 'John Doe', email: tEmail);
  final tServerFailure = ServerFailure(message: 'Invalid credentials');
  final tNetworkFailure = NetworkFailure();

  setUpAll(() {
    registerFallbackValue(LoginParams(email: '', password: ''));
  });

  setUp(() {
    mockUsecase = MockLoginUsecase();
  });

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state should be LoginInitial', () {
    final cubit = LoginCubit(mockUsecase);
    expect(cubit.state, const LoginInitial());
    cubit.close();
  });

  // ── Success ────────────────────────────────────────────────────────────────
  blocTest<LoginCubit, LoginState>(
    'emits [LoginLoading, LoginSuccess] when login succeeds',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));
      return LoginCubit(mockUsecase);
    },
    act: (cubit) => cubit.login(email: tEmail, password: tPassword),
    expect: () => [const LoginLoading(), LoginSuccess(user: tUser)],
    verify: (_) {
      verify(() => mockUsecase.call(params: any(named: 'params'))).called(1);
    },
  );

  // ── Server failure ─────────────────────────────────────────────────────────
  blocTest<LoginCubit, LoginState>(
    'emits [LoginLoading, LoginFailed] when server returns an error',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Left(tServerFailure));
      return LoginCubit(mockUsecase);
    },
    act: (cubit) => cubit.login(email: tEmail, password: tPassword),
    expect: () => [const LoginLoading(), LoginFailed(failure: tServerFailure)],
  );

  // ── Network failure ────────────────────────────────────────────────────────
  blocTest<LoginCubit, LoginState>(
    'emits [LoginLoading, LoginFailed] when there is no internet',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Left(tNetworkFailure));
      return LoginCubit(mockUsecase);
    },
    act: (cubit) => cubit.login(email: tEmail, password: tPassword),
    expect: () => [const LoginLoading(), LoginFailed(failure: tNetworkFailure)],
  );

  // ── Correct params forwarding ──────────────────────────────────────────────
  blocTest<LoginCubit, LoginState>(
    'passes exact email and password to the use-case',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));
      return LoginCubit(mockUsecase);
    },
    act: (cubit) => cubit.login(email: tEmail, password: tPassword),
    verify: (_) {
      final captured = verify(
        () => mockUsecase.call(params: captureAny(named: 'params')),
      ).captured;
      final params = captured.first as LoginParams;
      expect(params.email, tEmail);
      expect(params.password, tPassword);
    },
  );

  // ── Multiple calls ─────────────────────────────────────────────────────────
  blocTest<LoginCubit, LoginState>(
    'returns to Loading→Success state each time login is called',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));
      return LoginCubit(mockUsecase);
    },
    act: (cubit) async {
      await cubit.login(email: tEmail, password: tPassword);
      await cubit.login(email: tEmail, password: tPassword);
    },
    expect: () => [
      const LoginLoading(),
      LoginSuccess(user: tUser),
      const LoginLoading(),
      LoginSuccess(user: tUser),
    ],
  );
}

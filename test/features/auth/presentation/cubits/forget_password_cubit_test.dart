import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:tech_nest/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';

class MockForgetPasswordUsecase extends Mock implements ForgetPasswordUsecase {}

void main() {
  late MockForgetPasswordUsecase mockUsecase;

  const tEmail = 'test@example.com';
  final tServerFailure = ServerFailure(message: 'Email not found');
  final tNetworkFailure = NetworkFailure();

  setUp(() {
    mockUsecase = MockForgetPasswordUsecase();
  });

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state should be ForgetPasswordInitial', () {
    final cubit = ForgetPasswordCubit(mockUsecase);
    expect(cubit.state, const ForgetPasswordInitial());
    cubit.close();
  });

  // ── Success ────────────────────────────────────────────────────────────────
  blocTest<ForgetPasswordCubit, ForgetPasswordState>(
    'emits [ForgetPasswordLoading, ForgetPasswordSuccess] when email is found',
    build: () {
      when(
        () => mockUsecase.call(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(null));
      return ForgetPasswordCubit(mockUsecase);
    },
    act: (cubit) => cubit.forgetPassword(email: tEmail),
    expect: () => [
      const ForgetPasswordLoading(),
      const ForgetPasswordSuccess(),
    ],
    verify: (_) {
      verify(() => mockUsecase.call(email: tEmail)).called(1);
    },
  );

  // ── Server failure ─────────────────────────────────────────────────────────
  blocTest<ForgetPasswordCubit, ForgetPasswordState>(
    'emits [ForgetPasswordLoading, ForgetPasswordFailed] on server error',
    build: () {
      when(
        () => mockUsecase.call(email: any(named: 'email')),
      ).thenAnswer((_) async => Left(tServerFailure));
      return ForgetPasswordCubit(mockUsecase);
    },
    act: (cubit) => cubit.forgetPassword(email: tEmail),
    expect: () => [
      const ForgetPasswordLoading(),
      ForgetPasswordFailed(failure: tServerFailure),
    ],
  );

  // ── Network failure ────────────────────────────────────────────────────────
  blocTest<ForgetPasswordCubit, ForgetPasswordState>(
    'emits [ForgetPasswordLoading, ForgetPasswordFailed] when offline',
    build: () {
      when(
        () => mockUsecase.call(email: any(named: 'email')),
      ).thenAnswer((_) async => Left(tNetworkFailure));
      return ForgetPasswordCubit(mockUsecase);
    },
    act: (cubit) => cubit.forgetPassword(email: tEmail),
    expect: () => [
      const ForgetPasswordLoading(),
      ForgetPasswordFailed(failure: tNetworkFailure),
    ],
  );

  // ── Email forwarding ───────────────────────────────────────────────────────
  blocTest<ForgetPasswordCubit, ForgetPasswordState>(
    'passes the exact email to the use-case',
    build: () {
      when(
        () => mockUsecase.call(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(null));
      return ForgetPasswordCubit(mockUsecase);
    },
    act: (cubit) => cubit.forgetPassword(email: tEmail),
    verify: (_) {
      final captured = verify(
        () => mockUsecase.call(email: captureAny(named: 'email')),
      ).captured;
      expect(captured.first, tEmail);
    },
  );
}

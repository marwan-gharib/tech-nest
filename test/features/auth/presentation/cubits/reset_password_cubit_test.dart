import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/params/reset_password_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tech_nest/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';

class MockResetPasswordUsecase extends Mock implements ResetPasswordUsecase {}

void main() {
  late MockResetPasswordUsecase mockUsecase;

  final tParams = ResetPasswordParams(
    email: 'test@example.com',
    code: '111222',
    newPass: 'NewPass123',
  );
  final tServerFailure = ServerFailure(message: 'Code expired');

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockUsecase = MockResetPasswordUsecase();
  });

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state should be ResetPasswordInitial', () {
    final cubit = ResetPasswordCubit(mockUsecase);
    expect(cubit.state, const ResetPasswordInitial());
    cubit.close();
  });

  // ── Success ────────────────────────────────────────────────────────────────
  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'emits [ResetPasswordLoading, ResetPasswordSuccess] when password is reset',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => const ApiSuccess(null));
      return ResetPasswordCubit(mockUsecase);
    },
    act: (cubit) => cubit.resetPassword(
      email: tParams.email,
      code: tParams.code,
      newPass: tParams.newPass,
    ),
    expect: () => [const ResetPasswordLoading(), const ResetPasswordSuccess()],
    verify: (_) {
      verify(() => mockUsecase.call(params: any(named: 'params'))).called(1);
    },
  );

  // ── Server failure ─────────────────────────────────────────────────────────
  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'emits [ResetPasswordLoading, ResetPasswordFailed] on server error',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => ApiFailure(tServerFailure));
      return ResetPasswordCubit(mockUsecase);
    },
    act: (cubit) => cubit.resetPassword(
      email: tParams.email,
      code: tParams.code,
      newPass: tParams.newPass,
    ),
    expect: () => [
      const ResetPasswordLoading(),
      ResetPasswordFailed(failure: tServerFailure),
    ],
  );

  // ── Params forwarding ─────────────────────────────────────────────────────
  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'passes exact email, code and newPass to the use-case',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => const ApiSuccess(null));
      return ResetPasswordCubit(mockUsecase);
    },
    act: (cubit) => cubit.resetPassword(
      email: tParams.email,
      code: tParams.code,
      newPass: tParams.newPass,
    ),
    verify: (_) {
      final captured = verify(
        () => mockUsecase.call(params: captureAny(named: 'params')),
      ).captured;
      final params = captured.first as ResetPasswordParams;
      expect(params.email, tParams.email);
      expect(params.code, tParams.code);
      expect(params.newPass, tParams.newPass);
    },
  );
}

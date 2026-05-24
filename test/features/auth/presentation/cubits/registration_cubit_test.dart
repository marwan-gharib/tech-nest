import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/features/auth/domain/params/sign_up_params.dart';
import 'package:tech_nest/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tech_nest/features/auth/presentation/cubits/registration_cubit/registration_cubit.dart';

class MockSignUpUsecase extends Mock implements SignUpUsecase {}

void main() {
  late MockSignUpUsecase mockUsecase;

  const tName = 'Jane Doe';
  const tEmail = 'jane@example.com';
  const tPassword = 'StrongPass1';

  final tUser = UserEntity(id: 2, name: tName, email: tEmail);
  final tServerFailure = ServerFailure(message: 'Email already exists');
  final tNetworkFailure = NetworkFailure();

  setUpAll(() {
    registerFallbackValue(
      SignUpParams(name: '', email: '', password: '', img: File('')),
    );
  });

  setUp(() {
    mockUsecase = MockSignUpUsecase();
  });

  RegistrationCubit buildCubitWithImage() {
    final cubit = RegistrationCubit(mockUsecase);
    // Simulate that the user has picked a profile image (required by signUp)
    cubit.profileImg = XFile('fake/path/image.jpg');
    return cubit;
  }

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state should be RegistrationInitial', () {
    final cubit = RegistrationCubit(mockUsecase);
    expect(cubit.state, const RegistrationInitial());
    cubit.close();
  });

  // ── Success ────────────────────────────────────────────────────────────────
  blocTest<RegistrationCubit, RegistrationState>(
    'emits [RegistrationLoading, RegistrationSuccess] when sign-up succeeds',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));
      return buildCubitWithImage();
    },
    act: (cubit) =>
        cubit.signUp(name: tName, email: tEmail, password: tPassword),
    expect: () => [
      const RegistrationLoading(),
      RegistrationSuccess(user: tUser),
    ],
    verify: (_) {
      verify(() => mockUsecase.call(params: any(named: 'params'))).called(1);
    },
  );

  // ── Server failure ─────────────────────────────────────────────────────────
  blocTest<RegistrationCubit, RegistrationState>(
    'emits [RegistrationLoading, RegistrationFailed] on server error',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Left(tServerFailure));
      return buildCubitWithImage();
    },
    act: (cubit) =>
        cubit.signUp(name: tName, email: tEmail, password: tPassword),
    expect: () => [
      const RegistrationLoading(),
      RegistrationFailed(failure: tServerFailure),
    ],
  );

  // ── Network failure ────────────────────────────────────────────────────────
  blocTest<RegistrationCubit, RegistrationState>(
    'emits [RegistrationLoading, RegistrationFailed] on network error',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Left(tNetworkFailure));
      return buildCubitWithImage();
    },
    act: (cubit) =>
        cubit.signUp(name: tName, email: tEmail, password: tPassword),
    expect: () => [
      const RegistrationLoading(),
      RegistrationFailed(failure: tNetworkFailure),
    ],
  );

  // ── Params forwarding ─────────────────────────────────────────────────────
  blocTest<RegistrationCubit, RegistrationState>(
    'passes name, email and password to the use-case correctly',
    build: () {
      when(
        () => mockUsecase.call(params: any(named: 'params')),
      ).thenAnswer((_) async => Right(tUser));
      return buildCubitWithImage();
    },
    act: (cubit) =>
        cubit.signUp(name: tName, email: tEmail, password: tPassword),
    verify: (_) {
      final captured = verify(
        () => mockUsecase.call(params: captureAny(named: 'params')),
      ).captured;
      final params = captured.first as SignUpParams;
      expect(params.name, tName);
      expect(params.email, tEmail);
      expect(params.password, tPassword);
    },
  );

  // ── profileImg is null guard ───────────────────────────────────────────────
  test(
    'throws StateError when profileImg is null and signUp is called',
    () async {
      // Arrange – no profileImg set
      final cubit = RegistrationCubit(mockUsecase);

      // Act & Assert — the cubit calls profileImg!.path which throws
      await expectLater(
        cubit.signUp(name: tName, email: tEmail, password: tPassword),
        throwsA(isA<Error>()),
      );
      cubit.close();
    },
  );
}

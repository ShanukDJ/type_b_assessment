import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/constants/app_strings.dart';
import 'package:type_b/core/errors/failures.dart';
import 'package:type_b/core/services/biometric_service.dart';
import 'package:type_b/core/utils/result.dart';
import 'package:type_b/features/auth/domain/entities/user_entity.dart';
import 'package:type_b/features/auth/domain/repositories/auth_repository.dart';
import 'package:type_b/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:type_b/features/auth/presentation/bloc/auth_event.dart';
import 'package:type_b/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBiometricService extends Mock implements BiometricService {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockBiometricService mockBiometricService;
  late AuthBloc authBloc;

  const tUser = UserEntity(
    id: 1,
    username: 'emilys',
    email: 'emily@example.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    accessToken: 'jwt-123',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockBiometricService = MockBiometricService();
    authBloc = AuthBloc(
      authRepository: mockAuthRepository,
      biometricService: mockBiometricService,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initialState_isAuthInitial', () {
      expect(authBloc.state, equals(const AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'appStarted_whenSessionValid_emitsAuthenticated',
      build: () {
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Success(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AppStartedEvent()),
      expect: () => [const AuthLoading(), const Authenticated(tUser)],
      verify: (_) {
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'appStarted_whenNoSession_emitsUnauthenticated',
      build: () {
        when(() => mockAuthRepository.getCurrentUser()).thenAnswer(
          (_) async => const FailureResult(AuthFailure('No session')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AppStartedEvent()),
      expect: () => [const AuthLoading(), const Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'loginSubmitted_withValidCredentials_emitsLoadingThenAuthenticated',
      build: () {
        when(
          () => mockAuthRepository.login(
            username: 'emilys',
            password: 'emilyspass',
          ),
        ).thenAnswer((_) async => const Success(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginSubmittedEvent(username: 'emilys', password: 'emilyspass'),
      ),
      expect: () => [const AuthLoading(), const Authenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'loginSubmitted_withInvalidCredentials_emitsLoadingThenAuthFailureState',
      build: () {
        when(
          () => mockAuthRepository.login(
            username: 'emilys',
            password: 'wrongpassword',
          ),
        ).thenAnswer(
          (_) async =>
              const FailureResult(AuthFailure('Invalid username or password')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginSubmittedEvent(
          username: 'emilys',
          password: 'wrongpassword',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthFailureState('Invalid username or password'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'registerSubmitted_withValidData_emitsLoadingThenRegistrationSuccessState',
      build: () {
        when(
          () => mockAuthRepository.register(
            firstName: 'Emily',
            lastName: 'Johnson',
            username: 'emilys',
            email: 'emily@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => const Success(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const RegisterSubmittedEvent(
          firstName: 'Emily',
          lastName: 'Johnson',
          username: 'emilys',
          email: 'emily@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const RegistrationSuccessState(
          user: tUser,
          message: AppStrings.registrationSuccess,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'biometricLoginRequested_whenBiometricsAvailableAndSuccessful_emitsAuthenticated',
      build: () {
        when(
          () => mockBiometricService.isBiometricsAvailable(),
        ).thenAnswer((_) async => true);
        when(
          () => mockBiometricService.authenticate(reason: any(named: 'reason')),
        ).thenAnswer((_) async => true);
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Success(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const BiometricLoginRequestedEvent()),
      expect: () => [const AuthLoading(), const Authenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'logoutRequested_clearsAuthAndEmitsUnauthenticated',
      build: () {
        when(
          () => mockAuthRepository.logout(),
        ).thenAnswer((_) async => const Success(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LogoutRequestedEvent()),
      expect: () => [const AuthLoading(), const Unauthenticated()],
      verify: (_) {
        verify(() => mockAuthRepository.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'clearAuthError_emitsUnauthenticated',
      build: () => authBloc,
      act: (bloc) => bloc.add(const ClearAuthErrorEvent()),
      expect: () => [const Unauthenticated()],
    );
  });
}

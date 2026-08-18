import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/biometric_service.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final BiometricService biometricService;

  AuthBloc({required this.authRepository, BiometricService? biometricService})
    : biometricService = biometricService ?? BiometricServiceImpl(),
      super(const AuthInitial()) {
    on<AppStartedEvent>(_onAppStarted);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<RegisterSubmittedEvent>(_onRegisterSubmitted);
    on<BiometricLoginRequestedEvent>(_onBiometricLoginRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<ClearAuthErrorEvent>(_onClearAuthError);
  }

  Future<void> _onAppStarted(
    AppStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authRepository.getCurrentUser();

    result.when(
      success: (user) => emit(Authenticated(user)),
      failure: (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.login(
      username: event.username,
      password: event.password,
    );

    result.when(
      success: (user) => emit(Authenticated(user)),
      failure: (failure) => emit(AuthFailureState(failure.message)),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.register(
      firstName: event.firstName,
      lastName: event.lastName,
      username: event.username,
      email: event.email,
      password: event.password,
    );

    result.when(
      success: (user) => emit(
        RegistrationSuccessState(
          user: user,
          message: AppStrings.registrationSuccess,
        ),
      ),
      failure: (failure) => emit(AuthFailureState(failure.message)),
    );
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isAvailable = await biometricService.isBiometricsAvailable();
    if (!isAvailable) {
      emit(
        const AuthFailureState(
          'Biometric authentication is not supported on this device.',
        ),
      );
      return;
    }

    final authenticated = await biometricService.authenticate(
      reason: 'Scan your biometric credential to login',
    );

    if (authenticated) {
      emit(const AuthLoading());
      final result = await authRepository.getCurrentUser();
      result.when(
        success: (user) => emit(Authenticated(user)),
        failure: (_) {
          // If no active session, perform quick demo biometric login
          add(
            const LoginSubmittedEvent(
              username: 'emilys',
              password: 'emilyspass',
            ),
          );
        },
      );
    } else {
      emit(const AuthFailureState(AppStrings.biometricAuthFailed));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await authRepository.logout();
    emit(const Unauthenticated());
  }

  void _onClearAuthError(ClearAuthErrorEvent event, Emitter<AuthState> emit) {
    emit(const Unauthenticated());
  }
}

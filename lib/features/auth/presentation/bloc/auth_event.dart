import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStartedEvent extends AuthEvent {
  const AppStartedEvent();
}

class LoginSubmittedEvent extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;

  const LoginSubmittedEvent({
    required this.username,
    required this.password,
    this.rememberMe = true,
  });

  @override
  List<Object?> get props => [username, password, rememberMe];
}

class RegisterSubmittedEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;

  const RegisterSubmittedEvent({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [firstName, lastName, username, email, password];
}

class BiometricLoginRequestedEvent extends AuthEvent {
  const BiometricLoginRequestedEvent();
}

class LogoutRequestedEvent extends AuthEvent {
  const LogoutRequestedEvent();
}

class ClearAuthErrorEvent extends AuthEvent {
  const ClearAuthErrorEvent();
}

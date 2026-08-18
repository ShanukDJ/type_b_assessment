import 'package:equatable/equatable.dart';
import '../constants/app_strings.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.noInternetConnection]);
}

class AuthFailure extends Failure {
  final int? statusCode;

  const AuthFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = AppStrings.storageError]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

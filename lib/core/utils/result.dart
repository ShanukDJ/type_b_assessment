import 'package:equatable/equatable.dart';

/// A type-safe representation of either Success with [S] or Failure with [F]
abstract class Result<S, F> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is FailureResult<S, F>;

  S? get dataOrNull => isSuccess ? (this as Success<S, F>).data : null;
  F? get failureOrNull =>
      isFailure ? (this as FailureResult<S, F>).failure : null;

  T when<T>({
    required T Function(S data) success,
    required T Function(F failure) failure,
  }) {
    if (this is Success<S, F>) {
      return success((this as Success<S, F>).data);
    } else {
      return failure((this as FailureResult<S, F>).failure);
    }
  }

  Result<R, F> map<R>(R Function(S data) transform) {
    if (this is Success<S, F>) {
      return Success(transform((this as Success<S, F>).data));
    } else {
      return FailureResult((this as FailureResult<S, F>).failure);
    }
  }

  T fold<T>(T Function(F failure) ifFailure, T Function(S data) ifSuccess) {
    if (this is Success<S, F>) {
      return ifSuccess((this as Success<S, F>).data);
    } else {
      return ifFailure((this as FailureResult<S, F>).failure);
    }
  }
}

class Success<S, F> extends Result<S, F> {
  final S data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

class FailureResult<S, F> extends Result<S, F> {
  final F failure;

  const FailureResult(this.failure);

  @override
  List<Object?> get props => [failure];
}

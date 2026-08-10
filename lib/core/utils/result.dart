/// Either / Result functional wrapper for error handling without throwing uncaught exceptions.
abstract class Result<F, S> {
  const Result();

  bool get isSuccess => this is Success<F, S>;
  bool get isFailure => this is Failure<F, S>;

  S? get data => isSuccess ? (this as Success<F, S>).value : null;
  F? get error => isFailure ? (this as Failure<F, S>).failure : null;

  T when<T>({
    required T Function(S data) success,
    required T Function(F error) failure,
  }) {
    if (this is Success<F, S>) {
      return success((this as Success<F, S>).value);
    } else {
      return failure((this as Failure<F, S>).failure);
    }
  }
}

class Success<F, S> extends Result<F, S> {
  final S value;
  const Success(this.value);
}

class Failure<F, S> extends Result<F, S> {
  final F failure;
  const Failure(this.failure);
}

/// Generic Failure object for Domain Layer errors
class AppFailure {
  final String message;
  final String? code;

  const AppFailure(this.message, [this.code]);

  @override
  String toString() => 'AppFailure: $message (Code: $code)';
}

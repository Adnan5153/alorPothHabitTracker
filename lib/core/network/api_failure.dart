/// Tagged-union style result for any operation that can fail. Keeps the
/// presentation layer from having to know about Firebase / REST exceptions
/// while still exposing enough context for the UI to react.
sealed class Result<T> {
  const Result();
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get valueOrNull => switch (this) {
        Success(value: final v) => v,
        Failure() => null,
      };

  Object? get errorOrNull => switch (this) {
        Success() => null,
        Failure(error: final e) => e,
      };
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

class Failure<T> extends Result<T> {
  const Failure(this.error, [this.message]);
  final Object error;
  final String? message;
}

typedef ErrorResult<T> = Result<T, String>;

sealed class Result<T, Q> {
  const Result();

  /// Creates an instance of Result containing a value
  factory Result.ok(T value) => Ok(value);

  /// Create an instance of Result containing an error
  factory Result.error(Q error) => Error(error);
}

/// Subclass of Result for values
final class Ok<T, Q> extends Result<T, Q> {
  const Ok(this.value);

  /// Returned value in result
  final T value;
}

/// Subclass of Result for errors
final class Error<T, Q> extends Result<T, Q> {
  const Error(this.error);

  /// Returned error in result
  final Q error;
}

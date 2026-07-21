sealed class OperationResult<T> {
  const OperationResult();
}

class OperationSuccess<T> extends OperationResult<T> {
  const OperationSuccess(this.value);

  final T value;
}

class OperationFailure<T> extends OperationResult<T> {
  const OperationFailure({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;
}

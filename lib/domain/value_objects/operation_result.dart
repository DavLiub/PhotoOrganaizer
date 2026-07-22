sealed class OperationResult<T> {
  const OperationResult();
}

class OperationSuccess<T> extends OperationResult<T> {
  const OperationSuccess(this.value);

  final T value;
}

enum FailureKind {
  permission,
  userAction,
  deviceState,
  background,
  storage,
  media,
  cloudAuth,
  cloudQuota,
  network,
  validation,
  cancelled,
  unknown,
}

class FailureInfo {
  const FailureInfo({
    required this.kind,
    required this.code,
    this.safeMessage,
    this.retryable = false,
    this.userActionRequired = false,
    this.diagnostics = const {},
  });

  final FailureKind kind;
  final String code;
  final String? safeMessage;
  final bool retryable;
  final bool userActionRequired;
  final Map<String, Object?> diagnostics;
}

class OperationFailure<T> extends OperationResult<T> {
  OperationFailure({
    required FailureKind kind,
    required String code,
    String? safeMessage,
    bool retryable = false,
    bool userActionRequired = false,
    Map<String, Object?> diagnostics = const {},
  }) : failure = FailureInfo(
         kind: kind,
         code: code,
         safeMessage: safeMessage,
         retryable: retryable,
         userActionRequired: userActionRequired,
         diagnostics: diagnostics,
       );

  const OperationFailure.fromInfo(this.failure);

  final FailureInfo failure;

  FailureKind get kind => failure.kind;

  String get code => failure.code;

  String? get safeMessage => failure.safeMessage;

  bool get retryable => failure.retryable;

  bool get userActionRequired => failure.userActionRequired;

  Map<String, Object?> get diagnostics => failure.diagnostics;
}

sealed class AppFailure {
  final String code;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  const AppFailure(this.code, this.message, {this.error, this.stackTrace});

  @override
  String toString() => 'AppFailure($code): $message';
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(String message, {Object? error, StackTrace? stackTrace})
      : super('network', message, error: error, stackTrace: stackTrace);
}

class AuthFailure extends AppFailure {
  const AuthFailure(String code, String message, {Object? error, StackTrace? stackTrace})
      : super(code, message, error: error, stackTrace: stackTrace);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure(String message, {Object? error, StackTrace? stackTrace})
      : super('unknown', message, error: error, stackTrace: stackTrace);
}

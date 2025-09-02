typedef LogSink = void Function(String level, String message, [Object? error, StackTrace? stackTrace]);

class Logger {
  static LogSink? _sink;

  static void setSink(LogSink sink) {
    _sink = sink;
  }

  static void _log(String level, String message, [Object? error, StackTrace? stackTrace]) {
    final sink = _sink;
    if (sink != null) {
      sink(level, message, error, stackTrace);
    } else {
      // Fallback to print
      final ts = DateTime.now().toIso8601String();
      // ignore: avoid_print
      print('[$ts][$level] $message${error != null ? ' | $error' : ''}');
      if (stackTrace != null) {
        // ignore: avoid_print
        print(stackTrace);
      }
    }
  }

  static void debug(String message) => _log('DEBUG', message);
  static void info(String message) => _log('INFO', message);
  static void warn(String message) => _log('WARN', message);
  static void error(String message, [Object? error, StackTrace? stackTrace]) => _log('ERROR', message, error, stackTrace);
}

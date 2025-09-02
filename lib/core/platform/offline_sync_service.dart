import 'dart:async';

/// OfflineSyncService
/// Lightweight write queue with retries for offline-first repositories.
/// Repositories can enqueue async operations (usually remote writes) and
/// the service will execute them when connectivity is available.
///
/// This is a minimal, framework-agnostic utility. Plug your connectivity
/// listener (e.g., connectivity_plus) to call setOnline(true/false).
class OfflineSyncService {
  final Duration retryDelay;
  final int maxRetries;

  bool _online = true;
  final _queue = <_QueuedOp>[];
  Timer? _timer;

  OfflineSyncService({this.retryDelay = const Duration(seconds: 3), this.maxRetries = 5});

  void setOnline(bool online) {
    _online = online;
    if (_online) {
      _drain();
    }
  }

  void enqueue(Future<void> Function() op) {
    _queue.add(_QueuedOp(op));
    _drain();
  }

  void _drain() {
    if (!_online) return;
    _timer ??= Timer(Duration.zero, _process);
  }

  Future<void> _process() async {
    _timer?.cancel();
    _timer = null;

    while (_queue.isNotEmpty && _online) {
      final job = _queue.first;
      try {
        await job.op();
        _queue.removeAt(0);
      } catch (_) {
        job.retries++;
        if (job.retries > maxRetries) {
          // drop the job after exceeding retries
          _queue.removeAt(0);
        } else {
          // re-enqueue with delay
          await Future.delayed(retryDelay);
        }
      }
    }
  }
}

class _QueuedOp {
  final Future<void> Function() op;
  int retries = 0;
  _QueuedOp(this.op);
}

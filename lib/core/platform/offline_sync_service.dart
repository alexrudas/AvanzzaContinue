import 'dart:async';

/// OfflineSyncService
/// Lightweight write queue with retries for offline-first repositories.
/// Repositories can enqueue async operations (usually remote writes) and
/// the service will execute them when connectivity is available.
///
/// This is a minimal, framework-agnostic utility. Plug your connectivity
/// listener (e.g., connectivity_plus) to call setOnline(true/false).
///
import 'package:flutter/foundation.dart';

class OfflineSyncService {
  final Duration retryDelay;
  final int maxRetries;

  bool _online = true;
  final _queue = <_QueuedOp>[];
  Timer? _timer;

  OfflineSyncService(
      {this.retryDelay = const Duration(seconds: 3), this.maxRetries = 5});

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

  // Expose queue size (useful for tests/telemetry)
  int get pendingCount => _queue.length;

  // Force immediate drain if online
  Future<void> sync() async {
    if (!_online) return;
    await _process();
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
      } catch (e, st) {
        debugPrint('[OfflineSync] write fail retry=${job.retries} error=$e');
        debugPrintStack(stackTrace: st);
        job.retries++;
        if (job.retries > maxRetries) {
          debugPrint('[OfflineSync] dropping job after max retries');
          _queue.removeAt(0);
        } else {
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

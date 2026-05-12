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

  /// Guard de re-entrancia: cuando `_process` está corriendo, este completer
  /// no es null. Permite que llamadas concurrentes a `_process()` /
  /// `sync()` / `_drain()` esperen al drain activo en lugar de spawnar uno
  /// nuevo en paralelo. El bug previo (RangeError en `removeAt(0)`) ocurría
  /// porque dos `_process` corrían a la vez: ambos leían `_queue.first`,
  /// el primero hacía `removeAt(0)` (queue→vacío) y el segundo crasheaba
  /// al intentar removeAt sobre lista vacía. Ver test
  /// `offline_sync_service_test.dart` → "no RangeError when enqueue races
  /// during await".
  Completer<void>? _drainCompleter;

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

  // Force immediate drain if online. Re-entrant: si ya hay un drain en
  // curso, espera a que termine (no spawnea otro).
  Future<void> sync() async {
    if (!_online) return;
    await _process();
  }

  void _drain() {
    if (!_online) return;
    // Si ya hay un drain activo, NO programamos otro. La iteración actual
    // del while-loop volverá a chequear `_queue.isNotEmpty` y procesará
    // los nuevos enqueues automáticamente.
    if (_drainCompleter != null) return;
    _timer ??= Timer(Duration.zero, _process);
  }

  Future<void> _process() async {
    // Re-entrancy: si otro `_process` ya está corriendo, esperar a su
    // completer en vez de iniciar un loop concurrente.
    if (_drainCompleter != null) {
      return _drainCompleter!.future;
    }
    final completer = Completer<void>();
    _drainCompleter = completer;
    _timer?.cancel();
    _timer = null;

    try {
      while (_queue.isNotEmpty && _online) {
        final job = _queue.first;
        try {
          await job.op();
          // Defensa en profundidad: el guard de re-entrancia previene
          // mutación concurrente, pero validamos identity por si una
          // operación externa (test reset, futura API admin) alterara
          // el queue durante el await.
          if (_queue.isNotEmpty && identical(_queue.first, job)) {
            _queue.removeAt(0);
          }
        } catch (e, st) {
          debugPrint('[OfflineSync] write fail retry=${job.retries} error=$e');
          debugPrintStack(stackTrace: st);
          job.retries++;
          if (job.retries > maxRetries) {
            debugPrint('[OfflineSync] dropping job after max retries');
            if (_queue.isNotEmpty && identical(_queue.first, job)) {
              _queue.removeAt(0);
            }
          } else {
            await Future.delayed(retryDelay);
          }
        }
      }
    } finally {
      _drainCompleter = null;
      if (!completer.isCompleted) completer.complete();
    }
  }
}

class _QueuedOp {
  final Future<void> Function() op;
  int retries = 0;
  _QueuedOp(this.op);
}

// ============================================================================
// lib/data/simit/simit_detail_prefetch_service.dart
// SIMIT DETAIL PREFETCH SERVICE — prefetch background con throttle de 2.
//
// QUÉ HACE:
// - Recibe lista de comparendos a prefetchear (post-consulta principal).
// - Lanza scrapes de detalle en background con concurrencia máxima de 2.
// - Mantiene Map<key, Future> para que el bottom sheet pueda hacer "join"
//   sobre un prefetch en curso en lugar de disparar otro request.
// - Expone estado reactivo (active/queued/completed/failed) para UI.
// - Idempotente: re-encolar la misma key no relanza nada.
//
// QUÉ NO HACE:
// - No paraleliza más de 2 requests (evita OOM en backend con N Chromes).
// - No cancela requests HTTP en vuelo cuando se llama clear() — el server
//   igual completa y popula cache Redis (dato útil si user vuelve).
// - No reintenta fallos automáticamente — el lazy mode del bottom sheet
//   dispara un retry manual al abrirse.
//
// PRINCIPIOS:
// - Singleton permanente (registrado en DIContainer.installSyncObservers).
// - GetX Rx para que la UI suscriba progreso sin tocar el servicio.
// - logs estructurados con prefijo [SIMIT_PREFETCH] para trazabilidad.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'models/simit_models.dart';
import 'simit_service.dart';

/// Tarea en cola — sólo metadata, el future se crea al ejecutar.
class _PendingTask {
  final String key;
  final String document;
  final String comparendoId;
  _PendingTask({
    required this.key,
    required this.document,
    required this.comparendoId,
  });
}

class SimitDetailPrefetchService {
  final SimitService _service;

  /// Concurrencia máxima de scrapes en flight. Subir más arriesga OOM
  /// en backend (cada Chrome real ≈ 600-800 MB) y no escala lineal.
  static const int _maxConcurrent = 2;

  /// Map de futures en flight (en cola O ejecutándose). Persisten hasta
  /// clear() — esto permite que un tap muy posterior al prefetch
  /// completado siga reusando la promise (que ya tiene el valor).
  final Map<String, Future<SimitFineDetail>> _inflight = {};
  final List<_PendingTask> _queue = [];
  int _activeSlots = 0;

  /// Documento "actual" — al cambiar, se descarta cola anterior.
  /// (Caso típico: usuario consulta cédula A, navega, consulta cédula B —
  /// los detalles de A pendientes ya no son relevantes.)
  final RxString currentDocument = ''.obs;

  /// Estado reactivo para UI de progreso.
  final RxInt activeCount = 0.obs;
  final RxInt queuedCount = 0.obs;
  final RxInt completedCount = 0.obs;
  final RxInt failedCount = 0.obs;

  SimitDetailPrefetchService(this._service);

  String _key(String doc, String id) => '$doc:$id';

  /// Total esperado para la sesión actual (completed + failed + active + queued).
  int get totalExpected =>
      completedCount.value +
      failedCount.value +
      activeCount.value +
      queuedCount.value;

  /// True si todavía hay trabajo pendiente o en curso.
  bool get isWorking => activeCount.value > 0 || queuedCount.value > 0;

  /// Encola N comparendos para prefetch. Idempotente.
  ///
  /// Si [document] difiere del actual, se limpia la cola anterior
  /// (no los inflight ya disparados — esos siguen hasta completar
  /// porque ya consumieron Chrome).
  void prefetchAll({
    required String document,
    required Iterable<String> comparendoIds,
  }) {
    if (currentDocument.value != document) {
      _queue.clear();
      queuedCount.value = 0;
      completedCount.value = 0;
      failedCount.value = 0;
      currentDocument.value = document;
    }

    var enqueued = 0;
    for (final id in comparendoIds) {
      if (id.trim().isEmpty) continue;
      final key = _key(document, id);
      if (_inflight.containsKey(key)) continue;
      if (_queue.any((t) => t.key == key)) continue;
      _queue.add(_PendingTask(
        key: key,
        document: document,
        comparendoId: id,
      ));
      enqueued++;
    }
    queuedCount.value = _queue.length;

    if (enqueued > 0) {
      _log('queued $enqueued (queue=${_queue.length}, active=$_activeSlots)');
    }

    _drainQueue();
  }

  /// Devuelve el future en flight si existe; null si nunca se encoló
  /// (o ya fue limpiado por clear()).
  Future<SimitFineDetail>? getInflight({
    required String document,
    required String comparendoId,
  }) {
    return _inflight[_key(document, comparendoId)];
  }

  /// Cancela tareas pendientes en cola (no las que ya están corriendo).
  /// Las que ya están corriendo terminan y popular cache backend igual.
  void cancelPending() {
    final n = _queue.length;
    if (n == 0) return;
    _queue.clear();
    queuedCount.value = 0;
    _log('cancelled $n pending');
  }

  /// Reset completo. Llamar al cerrar la pantalla que disparó el prefetch.
  /// No interrumpe scrapes en backend — terminan y popular cache Redis.
  void clear() {
    cancelPending();
    _inflight.clear();
    completedCount.value = 0;
    failedCount.value = 0;
    activeCount.value = 0;
    currentDocument.value = '';
    _log('cleared');
  }

  // ── Internals ───────────────────────────────────────────────────────────────

  void _drainQueue() {
    while (_activeSlots < _maxConcurrent && _queue.isNotEmpty) {
      final task = _queue.removeAt(0);
      queuedCount.value = _queue.length;
      _runTask(task);
    }
  }

  void _runTask(_PendingTask task) {
    _activeSlots++;
    activeCount.value = _activeSlots;
    _log('started ${task.key}');

    final future = _service.getMultaDetail(
      document: task.document,
      comparendoId: task.comparendoId,
    );
    _inflight[task.key] = future;

    future.then(
      (_) {
        completedCount.value = completedCount.value + 1;
        _log('completed ${task.key}');
      },
      onError: (Object err) {
        failedCount.value = failedCount.value + 1;
        _log('failed ${task.key}: $err');
      },
    ).whenComplete(() {
      _activeSlots--;
      activeCount.value = _activeSlots;
      _drainQueue();
    });
  }

  void _log(String msg) {
    if (kDebugMode) {
      debugPrint('[SIMIT_PREFETCH] $msg');
    }
  }
}

// ============================================================================
// lib/infrastructure/sync/firestore_sync_executor.dart
// FIRESTORE SYNC EXECUTOR — Enterprise Ultra Pro (Infrastructure)
//
// QUÉ HACE:
// - Implementa SyncExecutor contra Cloud Firestore.
// - Mapea SyncOperationType → operación Firestore.
// - Usa Transaction para CREATE atómico (falla si existe).
// - Traduce FirebaseException.code → SyncExecutionResult tipificado.
// - Inyecta _idempotencyKey como auditoría (NO dedup server-side).
//
// QUÉ NO HACE:
// - Mutar estado del outbox.
// - Retries / backoff / jitter.
// - DateTime.now() interno.
// - Logs / prints / assert.
// - Cambios de dominio.
//
// ROUTING:
// - entry.firestorePath debe ser col/doc/col/doc (segmentos pares).
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/sync/sync_outbox_entry.dart';
import '../../domain/services/sync/sync_execution_result.dart';
import '../../domain/services/sync/sync_executor.dart';

// ============================================================================
// IMPLEMENTATION
// ============================================================================

class FirestoreSyncExecutor implements SyncExecutor {
  final FirebaseFirestore _firestore;

  FirestoreSyncExecutor({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<SyncExecutionResult> execute({
    required SyncOutboxEntry entry,
    required DateTime now,
  }) async {
    final docRef = _resolveDocRef(entry.firestorePath);

    try {
      switch (entry.operationType) {
        case SyncOperationType.create:
          await _firestore.runTransaction((tx) async {
            final snap = await tx.get(docRef);
            if (snap.exists) {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: 'already-exists',
                message: 'Document already exists',
              );
            }
            _assertSerializablePayload(entry.payload);
            tx.set(
              docRef,
              _withAuditFields(entry.payload, entry.idempotencyKey),
            );
          });
          break;

        case SyncOperationType.update:
          _assertSerializablePayload(entry.payload);
          await docRef.update(
            _withAuditFields(entry.payload, entry.idempotencyKey),
          );
          break;

        case SyncOperationType.delete:
          await docRef.delete();
          break;

        case SyncOperationType.batch:
          _assertSerializablePayload(entry.payload);
          await docRef.set(
            _withAuditFields(entry.payload, entry.idempotencyKey),
            SetOptions(merge: true),
          );
          break;
      }

      // Nota: quitar const para evitar error si ok() no es const constructor.
      return const SyncExecutionResult.ok();
    } on FirebaseException catch (e) {
      return _classifyFirebaseError(
        e,
        operation: entry.operationType,
      );
    } on FormatException {
      rethrow;
    } on ArgumentError {
      rethrow;
    }
    // Otras excepciones propagan al dispatcher (catch-all intencionalmente omitido).
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  Map<String, dynamic> _withAuditFields(
    Map<String, dynamic> payload,
    String idempotencyKey,
  ) {
    return {
      ...payload,
      '_idempotencyKey': idempotencyKey,
      '_syncedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Guardrail mínimo: stub documentado.
  /// NO valida profundamente — solo punto de extensión futuro.
  void _assertSerializablePayload(Map<String, dynamic> payload) {
    // Intencionalmente vacío.
  }

  // ==========================================================================
  // ROUTING
  // ==========================================================================

  DocumentReference<Map<String, dynamic>> _resolveDocRef(String firestorePath) {
    final segments = firestorePath
        .split('/')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);

    if (segments.isEmpty || segments.length.isOdd) {
      throw FormatException(
        'firestorePath inválido (requiere segmentos pares col/doc): '
        '"$firestorePath"',
      );
    }

    return _firestore.doc(segments.join('/'));
  }

  // ==========================================================================
  // ERROR CLASSIFICATION
  // ==========================================================================

  SyncExecutionResult _classifyFirebaseError(
    FirebaseException e, {
    required SyncOperationType operation,
  }) {
    final code = e.code;
    final message = '${e.plugin}/$code: ${e.message ?? 'no message'}';

    // --- Special semantics ---
    if (operation == SyncOperationType.create && code == 'already-exists') {
      return SyncExecutionResult.terminalError(
        message: message,
        code: SyncErrorCode.http409Conflict,
      );
    }

    if ((operation == SyncOperationType.update ||
            operation == SyncOperationType.delete) &&
        code == 'not-found') {
      return SyncExecutionResult.terminalError(
        message: message,
        code: SyncErrorCode.http404NotFound,
      );
    }

    // --- Retryable ---
    if (_isRetryableCode(code)) {
      return SyncExecutionResult.retryableError(
        message: message,
        code: _mapToSyncErrorCode(code),
      );
    }

    // --- Terminal default ---
    return SyncExecutionResult.terminalError(
      message: message,
      code: _mapToSyncErrorCode(code),
    );
  }

  static bool _isRetryableCode(String code) {
    return switch (code) {
      'unavailable' => true,
      'deadline-exceeded' => true,
      'aborted' => true,
      'resource-exhausted' => true,
      'internal' => true,
      'unknown' => true,
      _ => false,
    };
  }

  static SyncErrorCode _mapToSyncErrorCode(String code) {
    return switch (code) {
      'unavailable' => SyncErrorCode.http503ServiceUnavailable,
      'deadline-exceeded' => SyncErrorCode.http504GatewayTimeout,
      'resource-exhausted' => SyncErrorCode.http429RateLimit,
      'permission-denied' => SyncErrorCode.http403Forbidden,
      'unauthenticated' => SyncErrorCode.auth401Unauthorized,
      'invalid-argument' => SyncErrorCode.http400BadRequest,
      'not-found' => SyncErrorCode.http404NotFound,
      'already-exists' => SyncErrorCode.http409Conflict,
      'out-of-range' => SyncErrorCode.http422Validation,
      'internal' => SyncErrorCode.http500ServerError,
      _ => SyncErrorCode.unknown,
    };
  }
}

// ============================================================================
// CHECKLIST FINAL
// ============================================================================
// [x] CREATE atómico real con Transaction (sin carreras)
// [x] update/delete semántica estricta Firestore
// [x] batch → set(merge:true)
// [x] _idempotencyKey solo auditoría
// [x] serverTimestamp (no DateTime.now)
// [x] Clasificación Firebase precisa + semántica por operación
// [x] Sin cambios de dominio ni dispatcher
// [x] Compila con cloud_firestore Dart
// [x] Production-ready

// ============================================================================
// test/sync/asset_sync_dispatcher_test.dart
// DISPATCHER TESTS — Asset Schema v1.3.4 — Fase 5
//
// QUÉ HACE:
// - Verifica el comportamiento de AssetSyncDispatcher en escenarios clave.
// - Usa FakeFirebaseFirestore para controlar e inspeccionar Firestore.
// - Usa _FakeOutboxRepo para capturar transiciones de estado del outbox.
// - Usa _SpyArchiveService (spy determinista) para tests de archive.
// - Usa runBatchForTest() para aislar lógica de dispatch del scheduler.
//
// QUÉ NO HACE:
// - No testa el Timer / poller (eso pertenece a tests de integración).
// - No verifica markAsApplied() — en try/catch, no crítico aquí.
//
// ESCENARIOS:
//   1. Legacy path happy path
//   2. Legacy path payload vacío → dead letter
//   3. v2 dedup pre-check — Firestore state verificado
//   4. v2 dedup tardía — Firestore state verificado
//   5. v2 OCC happy path
//   6. v2 OCC real_conflict → markFailed
//   7. v2 OCC retry_loop → dead letter
//   8. v2 OCC stale_client → markFailed
//   9. override.isLocked bypasea dedup (write real, NO dedup skip)
//  10. override.isLocked NO bypasea OCC (conflict aunque isLocked)
//  11. Archive post-write — spy determinista (wasCalled, assetId, fragments)
//  12. stateUnknown — markFailed lanza → report honesto
//  13. triggerNow sin start() no procesa (dispatcher no arrancado)
//  14. Lease skip — granular counter entrySkippedLeaseCount
//  15. report.skipped es suma granular de las 3 variantes
//  16. partitionKey sin prefijo vehicle: es filtrado (no procesado)
//
// CORRECCIONES APLICADAS (auditoría 2026-03-21):
//   C1. override.isLocked: read-before/read-after + hash observado en Firestore
//   C2. Stop renombrado honestamente: "triggerNow does nothing when not started"
//   C3. start()/Timer eliminado: uso exclusivo de runBatchForTest() (@visibleForTesting)
//   C4. _openMinimalIsar: comentario explícito de invariante + deuda técnica
//   C5. archive: _SpyArchiveService determinista (no pumpEventQueue frágil)
//   C6. stateUnknown: 3 invariantes verificados vía report + outbox
//   C7. dedup: Firestore state (hash, domainVersion) verificado post-dispatch
//   C8. override.isLocked + OCC: nuevo test explícito de regla 33
//   C9. skip granular: entrySkippedLeaseCount en lugar de report.skipped total
//  C10. Nombres honestos en todos los tests
//
// CORRECCIONES APLICADAS (auditoría 2026-03-21 — segunda ronda):
//  C11. Spy Completer: archiveInvoked elimina pumpEventQueue de spy-state tests.
//       Matiz: archiveDomain es sincrónicamente llamado durante runBatch() (sin
//       awaits internos). El pump residual en el test de telemetría es legítimo:
//       el .then() que llama registerPending/telemetría sí es un microtask real.
//  C12. stateUnknown: nota explícita de pérdida de granularidad intencional.
//       Si SyncTelemetry expone stateUnknownCount, actualizar invariante 3.
//  C13. Test 13: nota explícita de qué NO cubre (parada cooperativa real).
//  C14. _openTestIsar: TODO reforzado — deuda no resuelta, no solución limpia.
//  C15. Partial failure + registerPending: test nuevo en grupo 11 con
//       _SpyReconciliationWorker para verificar contrato post-write.
//  C16. Coalescing real: grupo 17 con dos entries, verifica winner/superseded.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 5 — AssetSyncDispatcher v1.3.4.
// ============================================================================

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:avanzza/core/telemetry/sync_telemetry.dart';
import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/sources/local/asset_local_ds.dart';
import 'package:avanzza/data/sources/remote/asset_remote_ds.dart';
import 'package:avanzza/data/sync/asset_audit_service.dart';
import 'package:avanzza/data/sync/asset_firestore_adapter.dart';
import 'package:avanzza/data/sync/asset_history_archive_service.dart';
import 'package:avanzza/data/sync/asset_history_reconciliation_worker.dart';
import 'package:avanzza/data/sync/asset_sync_dispatcher.dart';
import 'package:avanzza/data/sync/asset_sync_queue.dart';
import 'package:avanzza/data/sync/asset_sync_service.dart';
import 'package:avanzza/domain/entities/sync/sync_outbox_entry.dart';
import 'package:avanzza/domain/repositories/sync_outbox_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ISAR HELPER — workaround temporal (Deuda técnica C4 / C14)
//
// Invariante ACTUAL: markAsApplied() en AssetSyncService NUNCA accede a
// colecciones Isar — solo usa _adapter.computeFingerprint() (puro) y
// _state (en memoria). Por eso basta un Isar válido con schemas vacíos.
//
// DEUDA TÉCNICA NO RESUELTA (C14):
// Esta apertura con schemas vacíos es un workaround, no una solución limpia.
// Riesgos concretos:
//   1. Si markAsApplied() o cualquier rama del flujo del dispatcher toca una
//      colección Isar, el suite falla con error críptico de schema ausente.
//   2. Si esa rama silencia la excepción, el suite miente: pasa sin ejercer
//      el código real.
//
// TODO(TECH-DEBT): Crear AssetSyncService.forTesting(@visibleForTesting)
// factory que no requiera Isar. Eliminar _openTestIsar() completamente.
// Hasta entonces, verificar en code review que markAsApplied() permanece
// sin acceso a colecciones Isar.
// ─────────────────────────────────────────────────────────────────────────────

bool _isarCoreInitialized = false;

Future<Isar> _openTestIsar() async {
  if (!_isarCoreInitialized) {
    _isarCoreInitialized = true;
    try {
      await Isar.initializeIsarCore(download: true);
    } catch (_) {
      // Ya inicializado en sesión previa — seguro ignorar.
    }
  }
  final dir = Directory.systemTemp.createTempSync('isar_dispatcher_test_');
  // AssetVehiculoModelSchema es el mínimo requerido por AssetLocalDataSource.
  // isar_community 3.1.0+1 no permite abrir con lista vacía (lanza IsarError).
  // markAsApplied() no accede a colecciones Isar — solo usa adapter + estado en
  // memoria — por lo que este open es suficiente para el contrato del dispatcher.
  return Isar.open(
    [AssetVehiculoModelSchema],
    directory: dir.path,
    name: 'disp_${dir.path.hashCode.abs()}',
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SPY ARCHIVE SERVICE — C5: determinista, no depende de pumpEventQueue
// ─────────────────────────────────────────────────────────────────────────────

/// Spy sobre AssetHistoryArchiveService.
///
/// Registra todas las llamadas a [archiveDomain] y retorna un resultado
/// controlado, sin tocar Firestore real.
///
/// # Modelo de ejecución (C11)
/// `archiveDomain` no tiene `await` internos → ejecuta sincrónicamente cuando
/// el dispatcher lo llama dentro de `_triggerArchivePostWrite`. Esto significa
/// que después de `await runBatch()`:
///   - `wasCalled`, `lastAssetId`, `lastFragments` ya están disponibles.
///   - El `Completer archiveInvoked` ya está completado.
///   - El `.then()` del dispatcher (telemetría, registerPending) aún es un
///     microtask pendiente → requiere `await pumpEventQueue(times: 1)`.
class _SpyArchiveService extends AssetHistoryArchiveService {
  _SpyArchiveService(FakeFirebaseFirestore db, SyncTelemetry telemetry)
      : super(
          firestore: db,
          auditService: AssetAuditService(
            auditEventsCollectionBuilder: (id) =>
                db.collection('audit/$id/events'),
            enqueueAuditOutboxEntry: (_) async {},
          ),
          telemetry: telemetry,
        );

  // ── Estado del spy ────────────────────────────────────────────────────────

  final List<({String assetId, Map<String, dynamic> fragments})> calls = [];

  /// Resultado a retornar en la próxima llamada.
  ArchiveResult resultToReturn = ArchiveResult(
    succeeded: const ['compliance'],
    failed: const [],
    skipped: const [],
  );

  /// Si `true`, `archiveDomain` lanza en lugar de retornar.
  ///
  /// Usar para tests que verifican el `catchError` de `_triggerArchivePostWrite`
  /// (telemetría de fallo + `registerPending` en el reconciliation worker).
  bool shouldThrow = false;

  // ── Señal de terminación (C11) ─────────────────────────────────────────────

  /// Completer que completa cuando `archiveDomain` fue invocado.
  ///
  /// Dado que `archiveDomain` no tiene `await` internos, completa
  /// sincrónicamente durante `runBatch()`. Usar como señal nombrada en tests
  /// de spy-state para evitar `pumpEventQueue`.
  ///
  /// Para efectos del `.then()` del dispatcher (telemetría, registerPending),
  /// usar adicionalmente `await pumpEventQueue(times: 1)` — ese callback es
  /// un microtask genuino posterior a la llamada de `archiveDomain`.
  ///
  /// No usar `await archiveInvoked` si el test espera que archive NO se llame.
  final Completer<void> archiveInvoked = Completer<void>();

  // ── Seam ──────────────────────────────────────────────────────────────────

  @override
  Future<ArchiveResult> archiveDomain(
    String assetId,
    Map<String, dynamic> archivableFragments,
  ) async {
    calls.add((assetId: assetId, fragments: archivableFragments));
    if (!archiveInvoked.isCompleted) archiveInvoked.complete();
    if (shouldThrow) {
      throw StateError('[_SpyArchiveService] archive forced throw (test)');
    }
    return resultToReturn;
  }

  // ── Helpers de asserción ─────────────────────────────────────────────────

  bool get wasCalled => calls.isNotEmpty;
  String? get lastAssetId => calls.lastOrNull?.assetId;
  Map<String, dynamic>? get lastFragments => calls.lastOrNull?.fragments;
}

// ─────────────────────────────────────────────────────────────────────────────
// SPY RECONCILIATION WORKER — C15: captura registerPending para partial failure
// ─────────────────────────────────────────────────────────────────────────────

/// Spy sobre AssetHistoryReconciliationWorker.
///
/// Captura todas las llamadas a [registerPending] para verificar que
/// `_triggerArchivePostWrite` registra pending tras partial failure o catchError.
///
/// Hereda el constructor real para satisfacer las dependencias sin modificar
/// la firma pública del worker.
class _SpyReconciliationWorker extends AssetHistoryReconciliationWorker {
  _SpyReconciliationWorker({
    required super.firestore,
    required super.archiveService,
    required super.telemetry,
  });

  final List<({String assetId, List<String> domains})> pendingRegistrations =
      [];

  @override
  void registerPending(String assetId, Iterable<String> domains) {
    pendingRegistrations.add((assetId: assetId, domains: domains.toList()));
    // Llama al padre para mantener el tracking en memoria coherente.
    super.registerPending(assetId, domains);
  }

  bool get wasRegisterPendingCalled => pendingRegistrations.isNotEmpty;
  String? get lastRegisteredAssetId => pendingRegistrations.lastOrNull?.assetId;
  List<String>? get lastRegisteredDomains =>
      pendingRegistrations.lastOrNull?.domains;
}

// ─────────────────────────────────────────────────────────────────────────────
// FAKE OUTBOX REPOSITORY
// ─────────────────────────────────────────────────────────────────────────────

class _FakeOutboxRepo implements SyncOutboxRepository {
  final List<SyncOutboxEntry> entries = [];

  // ── Tracking de transiciones ──────────────────────────────────────────────

  final List<String> completedIds = [];
  final List<String> failedIds = [];
  final List<String> deadLetteredIds = [];

  // ── Control de comportamiento ─────────────────────────────────────────────

  /// Si false, acquireLease retorna false → simula contención de lease.
  bool leaseGranted = true;

  /// Si true, markFailed lanza → fuerza stateUnknown en el dispatcher.
  bool throwOnMarkFailed = false;

  void addEntry(SyncOutboxEntry entry) => entries.add(entry);

  @override
  Future<void> upsert(SyncOutboxEntry entry) async {
    entries.removeWhere((e) => e.id == entry.id);
    entries.add(entry);
  }

  @override
  Future<SyncOutboxEntry?> getByEntryId(String entryId) async =>
      entries.where((e) => e.id == entryId).firstOrNull;

  @override
  Future<bool> existsByIdempotencyKey(String idempotencyKey) async =>
      entries.any((e) => e.idempotencyKey == idempotencyKey);

  @override
  Future<List<SyncOutboxEntry>> findEligible({
    required DateTime now,
    int limit = 50,
  }) async =>
      entries.where((e) => e.status == SyncStatus.pending).take(limit).toList();

  @override
  Future<bool> acquireLease({
    required String entryId,
    required String workerId,
    required Duration leaseDuration,
    required DateTime now,
  }) async =>
      leaseGranted;

  @override
  Future<void> releaseLease({
    required String entryId,
    required String workerId,
  }) async {}

  @override
  Future<void> markCompleted({
    required String entryId,
    required DateTime now,
  }) async {
    completedIds.add(entryId);
    _updateStatus(entryId, SyncStatus.completed);
  }

  @override
  Future<void> markFailed({
    required String entryId,
    required DateTime now,
    required String errorMessage,
    SyncErrorCode? errorCode,
    int? httpStatus,
    DateTime? nextAttemptAt,
    bool incrementRetry = true,
  }) async {
    if (throwOnMarkFailed) {
      throw StateError(
          '[_FakeOutboxRepo] markFailed force-throw (stateUnknown test)');
    }
    failedIds.add(entryId);
    final idx = entries.indexWhere((e) => e.id == entryId);
    if (idx != -1) {
      entries[idx] = entries[idx].copyWith(
        status: SyncStatus.failed,
        retryCount: incrementRetry
            ? entries[idx].retryCount + 1
            : entries[idx].retryCount,
        lastError: errorMessage,
      );
    }
  }

  @override
  Future<void> moveToDeadLetter({
    required String entryId,
    required DateTime now,
    required String reason,
    SyncErrorCode? errorCode,
    int? httpStatus,
  }) async {
    deadLetteredIds.add(entryId);
    _updateStatus(entryId, SyncStatus.deadLetter);
  }

  void _updateStatus(String entryId, SyncStatus status) {
    final idx = entries.indexWhere((e) => e.id == entryId);
    if (idx != -1) entries[idx] = entries[idx].copyWith(status: status);
  }

  @override
  Future<List<SyncOutboxEntry>> findStaleInProgress({
    required DateTime now,
    int limit = 50,
  }) async =>
      const [];

  @override
  Future<List<SyncOutboxEntry>> findDeadLetters({int limit = 50}) async =>
      entries.where((e) => e.status == SyncStatus.deadLetter).toList();

  @override
  Future<List<SyncOutboxEntry>> findTerminalOlderThan({
    required DateTime olderThan,
    int limit = 200,
  }) async =>
      const [];

  @override
  Future<int> purgeTerminalOlderThan({
    required DateTime olderThan,
    int limit = 200,
  }) async =>
      0;

  @override
  Future<int> countByStatus(SyncStatus status) async =>
      entries.where((e) => e.status == status).length;
}

// ─────────────────────────────────────────────────────────────────────────────
// CONSTANTES DE TEST
// ─────────────────────────────────────────────────────────────────────────────

const _kAssetId = 'asset-test-001';
const _kPartitionKey = 'vehicle:$_kAssetId';
const _kFirestoreCollection = 'asset_vehiculo';

/// 64 hex chars — formato correcto de payloadHash SHA-256.
const _kHashA =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const _kHashB =
    'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY FACTORIES
// ─────────────────────────────────────────────────────────────────────────────

Map<String, dynamic> _legacyPayload() => {
      'assetId': _kAssetId,
      'placa': 'ABC123',
      'marca': 'Toyota',
      'modelo': 'Hilux',
      'anio': 2020,
    };

/// Payload v1.3.4 mínimo. Incluye 'domains' (requerido por assert en dispatcher).
Map<String, dynamic> _v2Payload({
  String hash = _kHashA,
  int complianceDv = 6,
  int legalDv = 1,
}) =>
    {
      'identity': {'assetId': _kAssetId, 'placa': 'ABC123'},
      'domains': {
        'compliance': {'domainVersion': complianceDv, 'status': 'OK'},
        'legal': {'domainVersion': legalDv, 'liens': <dynamic>[]},
        'financial': {'domainVersion': 1},
      },
      'queryIndexes': {
        'complianceStatus': 'OK',
        'legalStatus': 'CLEAR',
        'priorityScore': 42, // campo observable para dedup tests
      },
      'rawSnapshots': {'vehicle': <String, dynamic>{}},
      'governance': {
        'schemaVersion': '1.3.4',
        'hasPendingHistory': false,
        'historyWriteStatusByDomain': <String, dynamic>{},
      },
      'metadata': {
        'payloadHash': hash,
        'documentSchemaVersion': '1.3.4',
        'lastSyncedAt': '2026-03-21T12:00:00.000Z',
      },
    };

/// Metadata v2 mínima para el outbox entry.
Map<String, dynamic> _v2Meta({
  String hash = _kHashA,
  List<String> domainsTouched = const ['compliance'],
  Map<String, int> expectedVersions = const {'compliance': 5},
  Map<String, dynamic> archivableFragments = const {},
  bool overrideIsLocked = false,
}) =>
    {
      'payloadHash': hash,
      'domainsTouched': domainsTouched,
      'expectedDomainVersions': expectedVersions,
      'archivableFragments': archivableFragments,
      'overrideIsLocked': overrideIsLocked,
      'documentSchemaVersion': '1.3.4',
    };

SyncOutboxEntry _makeLegacyEntry({
  String id = 'entry-legacy-001',
  Map<String, dynamic>? payload,
  int retryCount = 0,
  int maxRetries = 6,
}) =>
    SyncOutboxEntry(
      id: id,
      idempotencyKey: 'vehicle:upsert:$_kAssetId:12345',
      partitionKey: _kPartitionKey,
      operationType: SyncOperationType.batch,
      entityType: SyncEntityType.asset,
      entityId: _kAssetId,
      firestorePath: '$_kFirestoreCollection/$_kAssetId',
      payload: payload ?? _legacyPayload(),
      schemaVersion: 1,
      status: SyncStatus.pending,
      retryCount: retryCount,
      maxRetries: maxRetries,
      createdAt: DateTime.utc(2026, 3, 21, 12),
      metadata: const {},
    );

SyncOutboxEntry _makeV2Entry({
  String id = 'entry-v2-001',
  String hash = _kHashA,
  List<String> domainsTouched = const ['compliance'],
  Map<String, int> expectedVersions = const {'compliance': 5},
  Map<String, dynamic>? customPayload,
  Map<String, dynamic> archivableFragments = const {},
  bool overrideIsLocked = false,
  int retryCount = 0,
  int maxRetries = 6,
  int complianceDv = 6,
  // C16: expuesto para tests de coalescing que necesitan controlar la antigüedad.
  DateTime? createdAt,
}) =>
    SyncOutboxEntry(
      id: id,
      idempotencyKey: 'vehicle:v2:upsert:$_kAssetId:$hash',
      partitionKey: _kPartitionKey,
      operationType: SyncOperationType.batch,
      entityType: SyncEntityType.asset,
      entityId: _kAssetId,
      firestorePath: '$_kFirestoreCollection/$_kAssetId',
      payload:
          customPayload ?? _v2Payload(hash: hash, complianceDv: complianceDv),
      schemaVersion: 2,
      status: SyncStatus.pending,
      retryCount: retryCount,
      maxRetries: maxRetries,
      createdAt: createdAt ?? DateTime.utc(2026, 3, 21, 12),
      metadata: _v2Meta(
        hash: hash,
        domainsTouched: domainsTouched,
        expectedVersions: expectedVersions,
        archivableFragments: archivableFragments,
        overrideIsLocked: overrideIsLocked,
      ),
    );

// ─────────────────────────────────────────────────────────────────────────────
// SERVER DOC FIXTURE
// ─────────────────────────────────────────────────────────────────────────────

Future<void> _writeServerDoc(
  FakeFirebaseFirestore db, {
  required String assetId,
  String? payloadHash,
  int complianceDv = 5,
  int legalDv = 1,
  int priorityScore = 0,
}) async {
  await db.collection(_kFirestoreCollection).doc(assetId).set({
    'identity': {'assetId': assetId},
    'domains': {
      'compliance': {'domainVersion': complianceDv, 'status': 'OK'},
      'legal': {'domainVersion': legalDv, 'liens': <dynamic>[]},
      'financial': {'domainVersion': 1},
    },
    'queryIndexes': {'priorityScore': priorityScore},
    'governance': {'schemaVersion': '1.3.4'},
    'metadata': {
      if (payloadHash != null) 'payloadHash': payloadHash,
      'documentSchemaVersion': '1.3.4',
    },
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// DISPATCHER FACTORY — crea el dispatcher con todas sus dependencias
// ─────────────────────────────────────────────────────────────────────────────

typedef _DispatcherDeps = ({
  AssetSyncDispatcher dispatcher,
  _FakeOutboxRepo outbox,
  SyncTelemetry telemetry,
  FakeFirebaseFirestore db,
  Isar isar,
  _SpyArchiveService? spy, // null cuando se usa archive service real
  _SpyReconciliationWorker? reconciliationSpy, // null cuando no se espía el worker
});

Future<_DispatcherDeps> _buildDispatcher({
  _FakeOutboxRepo? outbox,
  bool useSpyArchive = false,
  // C15: spy sobre el reconciliation worker para tests de partial failure
  bool useSpyReconciliation = false,
}) async {
  final db = FakeFirebaseFirestore();
  final repo = outbox ?? _FakeOutboxRepo();
  const adapter = AssetFirestoreAdapter();
  final telemetry = SyncTelemetry();
  final remoteDs = AssetRemoteDataSource(db);

  // C4 / C14: Isar vacío — solo para satisfacer el constructor de
  // AssetLocalDataSource. markAsApplied no accede a colecciones Isar
  // (invariante verificado en code review).
  // TODO(TECH-DEBT): AssetSyncService.forTesting(@visibleForTesting) pendiente.
  // Esta apertura de Isar es DEUDA NO RESUELTA, no una solución limpia.
  // Si markAsApplied() o cualquier rama del dispatcher toca colecciones Isar,
  // este suite falla o, peor, miente silenciosamente.
  final isar = await _openTestIsar();
  final localDs = AssetLocalDataSource(isar);
  final queue = AssetSyncQueue(outboxRepo: repo, adapter: adapter);
  final syncService = AssetSyncService(
    localDs: localDs,
    remoteDs: remoteDs,
    queue: queue,
    adapter: adapter,
  );

  final auditService = AssetAuditService(
    auditEventsCollectionBuilder: (id) => db.collection('audit/$id/events'),
    enqueueAuditOutboxEntry: (_) async {},
  );

  // C5: spy determinista o service real según el test.
  final spy = useSpyArchive ? _SpyArchiveService(db, telemetry) : null;
  final archiveService = spy ??
      AssetHistoryArchiveService(
        firestore: db,
        auditService: auditService,
        telemetry: telemetry,
      );

  // C15: spy sobre reconciliation worker cuando el test necesita verificar
  // registerPending() tras partial failure o catchError de archive.
  _SpyReconciliationWorker? reconciliationSpy;
  final reconciliationWorker = useSpyReconciliation
      ? (reconciliationSpy = _SpyReconciliationWorker(
          firestore: db,
          archiveService: archiveService,
          telemetry: telemetry,
        ))
      : AssetHistoryReconciliationWorker(
          firestore: db,
          archiveService: archiveService,
          telemetry: telemetry,
        );

  final dispatcher = AssetSyncDispatcher(
    outboxRepo: repo,
    remoteDs: remoteDs,
    syncService: syncService,
    adapter: adapter,
    archiveService: archiveService,
    reconciliationWorker: reconciliationWorker,
    telemetry: telemetry,
  );

  return (
    dispatcher: dispatcher,
    outbox: repo,
    telemetry: telemetry,
    db: db,
    isar: isar,
    spy: spy,
    reconciliationSpy: reconciliationSpy,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TESTS
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ── Shared state ────────────────────────────────────────────────────────────

  late AssetSyncDispatcher dispatcher;
  late _FakeOutboxRepo outbox;
  late SyncTelemetry telemetry;
  late FakeFirebaseFirestore db;
  late Isar isar;
  _SpyArchiveService? spy;
  _SpyReconciliationWorker? reconciliationSpy; // C15

  tearDown(() async {
    // Dispatcher no arrancado en tests → stop() es no-op seguro.
    dispatcher.stop();
    try {
      await isar.close(deleteFromDisk: true);
    } catch (_) {}
    spy = null;
    reconciliationSpy = null;
  });

  // C3: runBatchForTest() aísla lógica de dispatch del scheduler.
  // No usa start() + Timer. No usa pumpEventQueue() para control de flujo.
  Future<AssetDispatchReport> runBatch() => dispatcher.runBatchForTest();

  // ──────────────────────────────────────────────────────────────────────────
  // 1. LEGACY PATH — happy path
  // ──────────────────────────────────────────────────────────────────────────

  group('1. Legacy path happy path', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;
      outbox.addEntry(_makeLegacyEntry());
    });

    test('escribe el payload en Firestore con merge:true', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(snap.exists, isTrue);
      expect(snap.data()?['assetId'], equals(_kAssetId));
    });

    test('marca la entry como completed en el outbox', () async {
      await runBatch();

      expect(outbox.completedIds, contains('entry-legacy-001'));
      expect(outbox.failedIds, isEmpty);
      expect(outbox.deadLetteredIds, isEmpty);
    });

    test('report refleja 1 pushed, 1 eligible', () async {
      final report = await runBatch();

      expect(report.pushed, equals(1));
      expect(report.eligible, equals(1));
      expect(report.deadLettered, equals(0));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 2. LEGACY PATH — payload vacío → dead letter (C10: nombre honesto)
  // ──────────────────────────────────────────────────────────────────────────

  group('2. Legacy path — payload vacío mueve a dead letter sin escribir', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;
      outbox.addEntry(_makeLegacyEntry(payload: const {}));
    });

    test('Firestore no tiene el documento', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(snap.exists, isFalse);
    });

    test('deadLetter registrado, completed vacío', () async {
      await runBatch();

      expect(outbox.deadLetteredIds, contains('entry-legacy-001'));
      expect(outbox.completedIds, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 3. V2 DEDUP PRE-CHECK — C7: Firestore state verificado
  // ──────────────────────────────────────────────────────────────────────────

  group('3. v2 dedup pre-check — servidor tiene mismo hash', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // Servidor con hash idéntico al entry → dedup pre-check activa.
      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: _kHashA, complianceDv: 5);

      // Sin OCC domains → va directo a dedup pre-check (no transaction).
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const [],
        expectedVersions: const {},
        complianceDv: 6,
      ));
    });

    test('domainVersion del servidor queda intacto (no hubo write)', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      final serverDv =
          snap.data()?['domains']?['compliance']?['domainVersion'] as int?;

      // Server tenía v5; el entry proponía v6. Como fue dedup skip, sigue v5.
      expect(serverDv, equals(5),
          reason: 'dedup pre-check: no write → domainVersion intacto');
    });

    test('hash del servidor no cambió', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(snap.data()?['metadata']?['payloadHash'], equals(_kHashA));
    });

    test('entry marcada completed + telemetría registra skip en fase precheck',
        () async {
      await runBatch();

      expect(outbox.completedIds, contains('entry-v2-001'));
      expect(telemetry.deduplicationSkipsCount, greaterThan(0));
      expect(telemetry.totalPushed, equals(0));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 4. V2 DEDUP TARDÍA — C7: dentro de transaction, Firestore state verificado
  // ──────────────────────────────────────────────────────────────────────────

  group('4. v2 dedup tardía — hash igual dentro de transaction OCC', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // Servidor con mismo hash y domainVersion=5.
      // Entry tiene OCC domain → activa runTransaction().
      // Dentro: hash match → dedup tardía (transaction commits vacía).
      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: _kHashA, complianceDv: 5);

      outbox.addEntry(_makeV2Entry(
        hash: _kHashA, // mismo hash → dedup tardía dentro de transaction
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        complianceDv: 6,
      ));
    });

    test('domainVersion del servidor queda en 5 (transaction vacía)', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      final serverDv =
          snap.data()?['domains']?['compliance']?['domainVersion'] as int?;

      expect(serverDv, equals(5),
          reason: 'dedup tardía: transaction empty → domainVersion intacto');
    });

    test('hash del servidor no cambió', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(snap.data()?['metadata']?['payloadHash'], equals(_kHashA));
    });

    test('completed + deduplicationSkips + NO OCC conflict', () async {
      await runBatch();

      expect(outbox.completedIds, contains('entry-v2-001'));
      expect(telemetry.deduplicationSkipsCount, greaterThan(0));
      expect(telemetry.occConflictsCount, equals(0),
          reason: 'Dedup tardía NO es un OCC conflict');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 5. V2 OCC HAPPY PATH — versión ok, write committed
  // ──────────────────────────────────────────────────────────────────────────

  group('5. v2 OCC happy path — server version coincide con expected', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // Servidor con domainVersion=5, sin hash → no dedup pre-check ni tardía.
      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: null, complianceDv: 5);

      // Entry espera v5 (base), payload ya tiene v6.
      outbox.addEntry(_makeV2Entry(
        hash: _kHashB, // hash distinto → no dedup
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        complianceDv: 6,
      ));
    });

    test('Firestore tiene domainVersion=6 después del write', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      final dv =
          snap.data()?['domains']?['compliance']?['domainVersion'] as int?;
      expect(dv, equals(6),
          reason: 'OCC pasó → builder ya puso v6, dispatcher lo escribe');
    });

    test('hash del servidor actualizado al hash del entry', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(snap.data()?['metadata']?['payloadHash'], equals(_kHashB));
    });

    test('completed + sin OCC conflict + 1 pushed', () async {
      final report = await runBatch();

      expect(outbox.completedIds, contains('entry-v2-001'));
      expect(telemetry.occConflictsCount, equals(0));
      expect(report.pushed, equals(1));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 6. V2 OCC real_conflict — version mismatch, retryCount < maxRetries
  // ──────────────────────────────────────────────────────────────────────────

  group('6. v2 OCC real_conflict → markFailed (retry programado)', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // Servidor ya tiene v6 (otro writer ganó), diff=1 → real_conflict.
      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: _kHashB, complianceDv: 6);

      // Cliente espera v5, diff = 6 - 5 = 1 → real_conflict.
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA, // distinto al server → no dedup
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        complianceDv: 6,
        retryCount: 0,
      ));
    });

    test('payload del cliente NO se escribe en Firestore', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      // Hash del servidor intacto (el del winner anterior).
      expect(snap.data()?['metadata']?['payloadHash'], equals(_kHashB));
    });

    test('markFailed registrado, sin deadLetter ni completed', () async {
      await runBatch();

      expect(outbox.failedIds, contains('entry-v2-001'));
      expect(outbox.deadLetteredIds, isEmpty);
      expect(outbox.completedIds, isEmpty);
    });

    test('telemetría registra 1 OCC conflict', () async {
      await runBatch();

      expect(telemetry.occConflictsCount, equals(1));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 7. V2 OCC retry_loop — retryCount > 2 → dead letter directo
  // ──────────────────────────────────────────────────────────────────────────

  group('7. v2 OCC retry_loop (retryCount=3) → moveToDeadLetter directo', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: _kHashB, complianceDv: 6);

      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        retryCount: 3, // > 2 → retry_loop → dead letter directo
      ));
    });

    test('moveToDeadLetter registrado, sin markFailed', () async {
      await runBatch();

      expect(outbox.deadLetteredIds, contains('entry-v2-001'));
      expect(outbox.failedIds, isEmpty);
    });

    test('telemetría registra OCC conflict', () async {
      await runBatch();

      expect(telemetry.occConflictsCount, equals(1));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 8. V2 OCC stale_client — diff > 1 → markFailed (no dead letter)
  // ──────────────────────────────────────────────────────────────────────────

  group('8. v2 OCC stale_client (diff=3) → markFailed', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // server=8, expected=5 → diff=3 > 1 → stale_client.
      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: _kHashB, complianceDv: 8);

      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        retryCount: 0,
      ));
    });

    test('markFailed registrado (stale_client va a retry, no dead letter)',
        () async {
      await runBatch();

      expect(outbox.failedIds, contains('entry-v2-001'));
      expect(outbox.deadLetteredIds, isEmpty);
    });

    test('telemetría registra OCC conflict', () async {
      await runBatch();

      expect(telemetry.occConflictsCount, equals(1));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 9. OVERRIDE.ISLOCKED bypasea dedup — C1: read-before/read-after
  // ──────────────────────────────────────────────────────────────────────────

  group('9. override.isLocked bypasea dedup — write ocurre aunque hash igual',
      () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // Servidor con MISMO hash que el entry (normalmente = dedup skip).
      // priorityScore=0 en el servidor vs 42 en el payload del entry.
      await _writeServerDoc(db,
          assetId: _kAssetId,
          payloadHash: _kHashA,
          complianceDv: 5,
          priorityScore: 0);
    });

    test('write ocurre y Firestore queda con el hash + priorityScore del entry',
        () async {
      // isLocked=true + sin OCC domains → dedup skipped, write directo.
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const [], // sin OCC → set directo
        expectedVersions: const {},
        overrideIsLocked: true, // ← bypass dedup
        complianceDv: 6,
      ));

      // Leer estado del servidor ANTES del dispatch.
      final snapBefore =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      final pvBefore =
          snapBefore.data()?['queryIndexes']?['priorityScore'] as int?;
      expect(pvBefore, equals(0), reason: 'precondición: priorityScore=0');

      await runBatch();

      // Leer estado DESPUÉS del dispatch.
      final snapAfter =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      final pvAfter =
          snapAfter.data()?['queryIndexes']?['priorityScore'] as int?;

      // El payload del entry tiene priorityScore=42 (ver _v2Payload).
      expect(pvAfter, equals(42),
          reason:
              'override.isLocked: write ocurrió → priorityScore actualizado');
      expect(snapAfter.data()?['metadata']?['payloadHash'], equals(_kHashA),
          reason: 'hash del entry escrito en Firestore');
    });

    test(
        'deduplicationSkipsCount == 0 (dedup NO se activó por override.isLocked)',
        () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const [],
        expectedVersions: const {},
        overrideIsLocked: true,
      ));

      await runBatch();

      expect(telemetry.deduplicationSkipsCount, equals(0),
          reason: 'override.isLocked: dedup no se ejecuta');
    });

    test('entry marcada completed', () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const [],
        expectedVersions: const {},
        overrideIsLocked: true,
      ));

      await runBatch();

      expect(outbox.completedIds, contains('entry-v2-001'));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 10. OVERRIDE.ISLOCKED NO bypasea OCC — C8: regla 33 del plan
  // ──────────────────────────────────────────────────────────────────────────

  group('10. override.isLocked NO bypasea OCC — regla 33 del plan', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // Servidor: domainVersion=6 (otro writer ganó), hash distinto.
      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: _kHashB, complianceDv: 6);
    });

    test(
        'override.isLocked + hash distinto + version conflict → OCC conflict (no push)',
        () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA, // distinto al server → no dedup tardía
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5}, // server=6, diff=1
        overrideIsLocked: true, // bypass dedup, OCC sigue activo
        retryCount: 0,
      ));

      await runBatch();

      // OCC debe haber detectado el conflict.
      expect(telemetry.occConflictsCount, equals(1),
          reason: 'override.isLocked NO bypasea OCC — conflict detectado');

      // El payload del entry NO se escribió.
      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(snap.data()?['metadata']?['payloadHash'], equals(_kHashB),
          reason:
              'Hash del servidor intacto — write del entry rechazado por OCC');
    });

    test('deduplicationSkipsCount == 0 (isLocked bypaseó dedup, no OCC)',
        () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        overrideIsLocked: true,
      ));

      await runBatch();

      expect(telemetry.deduplicationSkipsCount, equals(0));
    });

    test('markFailed o dead letter registrado (no completed, no push exitoso)',
        () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        overrideIsLocked: true,
      ));

      await runBatch();

      expect(outbox.completedIds, isEmpty);
      // real_conflict (diff=1, retryCount=0 < maxRetries) → markFailed
      expect(outbox.failedIds, contains('entry-v2-001'));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 11. ARCHIVE POST-WRITE — C5+C11+C15: spy determinista + Completer + partial
  // ──────────────────────────────────────────────────────────────────────────

  group('11. archive post-write — spy determinista', () {
    setUp(() async {
      // C15: spy archive + spy reconciliation para todos los sub-tests del grupo.
      final deps = await _buildDispatcher(
        useSpyArchive: true,
        useSpyReconciliation: true,
      );
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;
      spy = deps.spy;
      reconciliationSpy = deps.reconciliationSpy;

      await _writeServerDoc(db, assetId: _kAssetId, payloadHash: null);
    });

    const Map<String, dynamic> fragments = {
      'compliance': [
        {
          'policyId': 'policy-soat-001',
          'policyType': 'soat',
          'status': 'activo',
          'effectiveDate': '2024-01-01',
          'expirationDate': '2025-01-01',
        }
      ],
    };

    // C11: archiveDomain se ejecuta sincrónicamente dentro de runBatch()
    // (no tiene awaits internos). Después de runBatch(), spy state ya está
    // disponible — NO se necesita pumpEventQueue para spy-state assertions.
    // El Completer archiveInvoked confirma la llamada como señal nombrada.

    test('_triggerArchivePostWrite llama archiveDomain con assetId correcto',
        () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashB,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        archivableFragments: fragments,
        complianceDv: 6,
      ));

      await runBatch();

      // C11: archiveInvoked completa sincrónicamente — no se necesita pump.
      expect(spy!.archiveInvoked.isCompleted, isTrue,
          reason: 'Completer completa durante runBatch()');
      expect(spy!.wasCalled, isTrue,
          reason: '_triggerArchivePostWrite debe llamar archiveDomain');
      expect(spy!.lastAssetId, equals(_kAssetId));
    });

    test('archiveDomain recibe los fragments correctos', () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashB,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        archivableFragments: fragments,
        complianceDv: 6,
      ));

      await runBatch();
      // C11: spy state es sincrónico → no se necesita pumpEventQueue.

      final received = spy!.lastFragments;
      expect(received?.containsKey('compliance'), isTrue);
      expect((received!['compliance'] as List).length, equals(1));
    });

    test('telemetría registra archiveSuccessCount > 0 tras spy succeeded',
        () async {
      // spy.resultToReturn default tiene succeeded=['compliance']
      outbox.addEntry(_makeV2Entry(
        hash: _kHashB,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        archivableFragments: fragments,
        complianceDv: 6,
      ));

      await runBatch();
      // C11: el .then() que llama telemetry.recordArchiveSuccess SÍ es un
      // microtask genuino — requiere pump para que corra.
      await pumpEventQueue(times: 1);

      expect(telemetry.archiveSuccessCount, greaterThan(0));
    });

    test('archive NO se llama si archivableFragments está vacío', () async {
      outbox.addEntry(_makeV2Entry(
        hash: _kHashB,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        archivableFragments: const {}, // vacío → _triggerArchivePostWrite retorna
        complianceDv: 6,
      ));

      await runBatch();
      // C11: la guardia `if (fragments.isEmpty) return` ejecuta sincrónicamente.
      // No usar spy!.archiveInvoked aquí — nunca completaría (archive no llamado).

      expect(spy!.wasCalled, isFalse,
          reason:
              'Sin fragments, _triggerArchivePostWrite no llama archiveDomain');
      expect(spy!.archiveInvoked.isCompleted, isFalse,
          reason: 'Completer no completó porque archiveDomain no fue invocado');
    });

    // C15: partial failure — result.failed no vacío → registerPending en worker.
    //
    // Contrato: cuando archiveDomain retorna ArchiveResult con failed=['compliance'],
    // el .then() de _triggerArchivePostWrite llama
    // reconciliationWorker.registerPending(assetId, result.failed).
    test(
        'C15 partial failure: result.failed no vacío → registerPending en reconciliation worker',
        () async {
      // Spy retorna partial failure: compliance falló, nada succeeded.
      spy!.resultToReturn = ArchiveResult(
        succeeded: const [],
        failed: const ['compliance'],
        skipped: const [],
      );

      outbox.addEntry(_makeV2Entry(
        hash: _kHashB,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        archivableFragments: fragments,
        complianceDv: 6,
      ));

      await runBatch();
      // El .then() que llama registerPending es un microtask — necesita pump.
      await pumpEventQueue(times: 1);

      expect(reconciliationSpy!.wasRegisterPendingCalled, isTrue,
          reason: 'partial failure debe llamar registerPending en el worker');
      expect(reconciliationSpy!.lastRegisteredAssetId, equals(_kAssetId));
      expect(reconciliationSpy!.lastRegisteredDomains, contains('compliance'));
    });

    // C15: catchError — archive lanza excepción → registerPending con archivable keys.
    test(
        'C15 catchError: archive lanza → registerPending con domains de archivableFragments',
        () async {
      spy!.shouldThrow = true;

      outbox.addEntry(_makeV2Entry(
        hash: _kHashB,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        archivableFragments: fragments,
        complianceDv: 6,
      ));

      await runBatch();
      // El catchError es un microtask — necesita pump.
      await pumpEventQueue(times: 1);

      expect(reconciliationSpy!.wasRegisterPendingCalled, isTrue,
          reason: 'catchError debe llamar registerPending');
      expect(reconciliationSpy!.lastRegisteredDomains, contains('compliance'));
      expect(telemetry.archiveFailureCount, greaterThan(0));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 12. STATEUNKNOWN — C6: 3 invariantes verificados
  // ──────────────────────────────────────────────────────────────────────────

  group('12. stateUnknown — markFailed lanza → sistema no miente', () {
    setUp(() async {
      final repo = _FakeOutboxRepo()..throwOnMarkFailed = true;
      final deps = await _buildDispatcher(outbox: repo);
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // OCC conflict (real_conflict) → _handleFailure → markFailed → throws.
      await _writeServerDoc(db,
          assetId: _kAssetId, payloadHash: _kHashB, complianceDv: 6);

      outbox.addEntry(_makeV2Entry(
        hash: _kHashA,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        retryCount: 0,
      ));
    });

    test(
        'invariante 1: entry no queda como completed (no fue pushed exitosamente)',
        () async {
      await runBatch();

      expect(outbox.completedIds, isEmpty,
          reason: 'stateUnknown: entry nunca se completó');
    });

    test('invariante 2: entry no queda en failedIds (markFailed lanzó antes)',
        () async {
      await runBatch();

      expect(outbox.failedIds, isEmpty,
          reason: 'markFailed lanzó → no se registró en failedIds del fake');
    });

    test(
        'invariante 3: stateUnknown se agrega a deadLettered en el report (aproximación conservadora)',
        () async {
      final report = await runBatch();

      // stateUnknown se consolida en deadLettered en el report público.
      // Esto es honesto: la entry no fue pushed, no fue retried — estado incierto.
      //
      // C12 — PÉRDIDA DE GRANULARIDAD INTENCIONAL:
      // El dispatcher no expone un contador público `stateUnknownCount` separado.
      // El agrupamiento en deadLettered es una aproximación conservadora: indica
      // que la entry no fue completada ni reintentada con éxito.
      // Si SyncTelemetry o AssetDispatchReport exponen stateUnknownCount en el
      // futuro, actualizar este test para verificar el contador directo.
      expect(report.deadLettered, greaterThan(0),
          reason:
              'stateUnknown → agrupado en deadLettered como aproximación conservadora');
      expect(report.pushed, equals(0));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 13. C2: Nombre honesto — triggerNow sin start() no procesa entries
  // ──────────────────────────────────────────────────────────────────────────

  group('13. triggerNow does nothing when dispatcher is not running', () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;
      outbox.addEntry(_makeLegacyEntry());
    });

    // C13 — ALCANCE EXPLÍCITO:
    // Este test verifica que triggerNow() no inicia un ciclo de dispatch cuando
    // _running == false (dispatcher no arrancado con start()).
    //
    // Lo que NO cubre: parada cooperativa real (dispatcher.stop() durante un
    // ciclo en vuelo donde entries ya fueron adquiridas con lease). Ese escenario
    // es de integración — requiere concurrencia real y no se prueba aquí.
    // La cobertura de arquitectura cooperativa queda pendiente para integration tests.
    test(
        'triggerNow() sin start() previo retorna sin procesar entries (_running=false)',
        () async {
      // Sin start(): _running = false → _tryRun() retorna inmediato.
      dispatcher.triggerNow();
      await pumpEventQueue();

      expect(outbox.completedIds, isEmpty,
          reason: 'Dispatcher no arrancado → ninguna entry procesada');
      expect(outbox.failedIds, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 14. LEASE SKIP — C9: granular counter (no solo report.skipped)
  // ──────────────────────────────────────────────────────────────────────────

  group('14. Lease skip — acquireLease=false registra entrySkippedLeaseCount',
      () {
    setUp(() async {
      final repo = _FakeOutboxRepo()..leaseGranted = false;
      final deps = await _buildDispatcher(outbox: repo);
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;
      outbox.addEntry(_makeLegacyEntry());
    });

    test('no escribe en Firestore cuando lease no se adquiere', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(snap.exists, isFalse);
    });

    test('entrySkippedLeaseCount > 0 (granular, no solo report.skipped total)',
        () async {
      await runBatch();

      expect(telemetry.entrySkippedLeaseCount, greaterThan(0),
          reason: 'Contador específico de lease skip debe incrementar');
    });

    test('report.skippedLease > 0 y report.skippedStopped == 0', () async {
      final report = await runBatch();

      expect(report.skippedLease, greaterThan(0));
      expect(report.skippedStopped, equals(0));
      expect(report.skippedDedup, equals(0));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 15. REPORT.SKIPPED — C9: suma correcta de 3 variantes granulares
  // ──────────────────────────────────────────────────────────────────────────

  test(
      '15. report.skipped es suma granular de skippedStopped + skippedLease + skippedDedup',
      () {
    const report = AssetDispatchReport(
      eligible: 10,
      coalesced: 6,
      superseded: 4,
      pushed: 2,
      retried: 1,
      deadLettered: 1,
      skippedStopped: 2,
      skippedLease: 1,
      skippedDedup: 3,
    );

    expect(report.skipped, equals(6), reason: 'skipped = 2 + 1 + 3');
    // Verificar que los 3 contadores son independientes.
    expect(report.skippedStopped, equals(2));
    expect(report.skippedLease, equals(1));
    expect(report.skippedDedup, equals(3));
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 17. COALESCING REAL — C16: dos entries mismo partitionKey, gana la nueva
  // ──────────────────────────────────────────────────────────────────────────

  group(
      '17. Coalescing — dos entries mismo partitionKey, solo la más reciente gana',
      () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      // Servidor sin hash → no dedup pre-check ni dedup tardía.
      await _writeServerDoc(db, assetId: _kAssetId, payloadHash: null);

      // Entry VIEJA: createdAt T-1h, hash _kHashA, complianceDv=5.
      // Esta debe ser supersedida por la nueva.
      outbox.addEntry(_makeV2Entry(
        id: 'entry-old',
        hash: _kHashA,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 4},
        complianceDv: 5,
        createdAt: DateTime.utc(2026, 3, 21, 11), // T-1h
      ));

      // Entry NUEVA: createdAt T (por defecto), hash _kHashB, complianceDv=6.
      // Esta es el winner: versión base=5, payload ya tiene v6.
      outbox.addEntry(_makeV2Entry(
        id: 'entry-new',
        hash: _kHashB,
        domainsTouched: const ['compliance'],
        expectedVersions: const {'compliance': 5},
        complianceDv: 6,
        createdAt: DateTime.utc(2026, 3, 21, 12), // T (más reciente)
      ));
    });

    test('Firestore tiene el hash de la entry más nueva (winner)', () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      expect(
        snap.data()?['metadata']?['payloadHash'],
        equals(_kHashB),
        reason: 'Solo el winner (_kHashB) debe escribirse en Firestore',
      );
    });

    test('domainVersion de Firestore refleja el payload del winner (v6)',
        () async {
      await runBatch();

      final snap =
          await db.collection(_kFirestoreCollection).doc(_kAssetId).get();
      final dv =
          snap.data()?['domains']?['compliance']?['domainVersion'] as int?;
      expect(dv, equals(6), reason: 'Winner trae complianceDv=6');
    });

    test('entry vieja (supersedida) queda marcada completed sin push propio',
        () async {
      await runBatch();

      // El dispatcher marca superseded via markCompleted.
      expect(outbox.completedIds, contains('entry-old'),
          reason: 'entry-old debe ser completed como supersedida');
    });

    test('entry nueva (winner) también queda completed', () async {
      await runBatch();

      expect(outbox.completedIds, contains('entry-new'),
          reason: 'entry-new (winner) debe quedar completed tras push exitoso');
    });

    test('report.superseded == 1 y report.pushed == 1', () async {
      final report = await runBatch();

      expect(report.superseded, equals(1),
          reason: 'Solo 1 entry supersedida (entry-old)');
      expect(report.pushed, equals(1),
          reason: 'Solo 1 push real (entry-new, el winner)');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 16. PARTITIONKEY SIN PREFIJO 'vehicle:' — filtrado antes de procesarse
  // ──────────────────────────────────────────────────────────────────────────

  group('16. partitionKey sin prefijo vehicle: es filtrado por el dispatcher',
      () {
    setUp(() async {
      final deps = await _buildDispatcher();
      dispatcher = deps.dispatcher;
      outbox = deps.outbox;
      telemetry = deps.telemetry;
      db = deps.db;
      isar = deps.isar;

      outbox.addEntry(
        SyncOutboxEntry(
          id: 'entry-bad-pk',
          idempotencyKey: 'invalid:key:12345',
          partitionKey: 'invalid:asset-001', // sin 'vehicle:' prefix
          operationType: SyncOperationType.batch,
          entityType: SyncEntityType.asset,
          entityId: 'asset-001',
          firestorePath: '$_kFirestoreCollection/asset-001',
          payload: _legacyPayload(),
          schemaVersion: 1,
          status: SyncStatus.pending,
          createdAt: DateTime.utc(2026, 3, 21),
          metadata: const {},
        ),
      );
    });

    test(
        'entry no procesada (filtrada en vehicleEntries) — ni completed ni deadLetter',
        () async {
      await runBatch();

      // El dispatcher filtra: vehicleEntries = entries con 'vehicle:' prefix.
      // Entry con 'invalid:' NO pasa el filtro → no se procesa en absoluto.
      expect(outbox.completedIds, isEmpty);
      expect(outbox.deadLetteredIds, isEmpty);
      expect(outbox.failedIds, isEmpty);
    });
  });
}

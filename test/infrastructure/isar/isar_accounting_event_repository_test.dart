// ============================================================================
// test/infrastructure/isar/isar_accounting_event_repository_test.dart
// MOTOR FINANCIERO — Tests de integridad Isar — Enterprise Ultra Pro (Test)
//
// QUÉ VALIDA:
// - T1: atomicidad writeTxn (todo o nada — rollback real)
// - T2: idempotencia estricta (mismo hash = no-op; distinto hash = StateError)
// - T3: chain integrity + gap detection (prevHash + sequenceNumber)
// - T4: outbox idempotencyKey == event.hash siempre
// - T6: anti-tamper — modificar payloadJson sin actualizar hash → FormatException
// - T7: payloadHash checksum en reposo == SHA-256(payloadJson)
//
// REQUISITOS DE EJECUCIÓN:
//   flutter test test/infrastructure/isar/isar_accounting_event_repository_test.dart
//   (requiere flutter test para native Isar libs en desktop)
// ============================================================================

import 'dart:convert';

import 'package:avanzza/domain/entities/accounting/accounting_event.dart';
import 'package:avanzza/infrastructure/isar/entities/account_receivable_projection_entity.dart';
import 'package:avanzza/infrastructure/isar/entities/accounting_event_entity.dart';
import 'package:avanzza/infrastructure/isar/entities/outbox_event_entity.dart';
import 'package:avanzza/infrastructure/isar/repositories/isar_accounting_event_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../helpers/isar_test_db.dart';

// ============================================================================
// FACTORY HELPERS
// ============================================================================

/// Evento "inicializador": colección cero que establece saldoInicialCop.
/// - totalIngresadoCop=0 y splits=[] → saldoFinalCop == saldoInicial.
/// - Válido para cualquier primer evento de una entidad.
Map<String, dynamic> _initPayload(int saldoInicial) => {
      'saldoInicialCop': saldoInicial,
      'splits': <Map<String, dynamic>>[],
      'totalIngresadoCop': 0,
      'diferenciaCop': 0,
      'saldoFinalCop': saldoInicial,
    };

/// Payload válido de colección parcial.
/// Precondición: [montoCop] <= [saldoAnterior].
Map<String, dynamic> _collectPayload({
  required int saldoAnterior,
  required int montoCop,
}) =>
    {
      'splits': [
        {'montoCop': montoCop}
      ],
      'totalIngresadoCop': montoCop,
      'diferenciaCop': 0,
      'saldoFinalCop': saldoAnterior - montoCop,
    };

/// Payload intencionalmente inválido: falta la clave 'splits'.
/// → FormatException en AccountReceivableProjection._applyCollection().
Map<String, dynamic> _badCollectionPayload() => {
      'totalIngresadoCop': 50000,
      'saldoFinalCop': 50000,
      // 'splits' deliberadamente ausente
    };

/// Constructor tipado de AccountingEvent.
AccountingEvent _event({
  required String id,
  required String entityId,
  required Map<String, dynamic> payload,
  String entityType = 'account_receivable',
  String eventType = 'ar_collection_recorded',
  String actorId = 'u1',
  required DateTime occurredAt,
  String? prevHash,
}) =>
    AccountingEvent(
      id: id,
      entityType: entityType,
      entityId: entityId,
      eventType: eventType,
      occurredAt: occurredAt,
      recordedAt: occurredAt,
      actorId: actorId,
      payload: payload,
      prevHash: prevHash,
    );

// ============================================================================
// TESTS
// ============================================================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Isar isar;
  late IsarAccountingEventRepository repo;
  late DateTime now;

  setUp(() async {
    isar = await openTestIsar();
    repo = IsarAccountingEventRepository(isar);
    now = DateTime.now().toUtc();
  });

  tearDown(() async {
    await closeTestIsar(isar);
  });

  // ==========================================================================
  // TEST 1 — ATOMICIDAD: ROLLBACK COMPLETO (writeTxn all-or-nothing)
  // ==========================================================================
  //
  // Estrategia:
  // - E1 válido → se persiste correctamente.
  // - E2 con prevHash correcto pero payload inválido para apply() (falta 'splits').
  //   → appendAtomic pone el event entity en DB (step 3), luego projection.apply()
  //     lanza FormatException (step 5).
  //   → writeTxn hace rollback completo: event, projection y outbox de E2 desaparecen.

  group('appendAtomic_is_transactional_all_or_nothing', () {
    test('rollback elimina evento, outbox y no modifica proyección cuando apply() falla',
        () async {
      const entityId = 'AR-T1';

      // ── E1: inicializa la entidad con saldo=100000 (colección cero) ──────
      final e1 = _event(
        id: 'evt-t1-001',
        entityId: entityId,
        payload: _initPayload(100000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      // Verificar que E1 fue almacenado correctamente
      final e1Entity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e1.id)
          .findFirst();
      expect(e1Entity, isNotNull, reason: 'Pre-condición: E1 debe existir');

      // ── E2: chain válida, pero payload inválido (falta 'splits') ─────────
      // Falla en step 5 (projection.apply) DESPUÉS del put del evento (step 3).
      final e2Invalid = _event(
        id: 'evt-t1-002',
        entityId: entityId,
        payload: _badCollectionPayload(),
        occurredAt: now.add(const Duration(seconds: 1)),
        prevHash: e1.hash,
      );

      Object? caught;
      try {
        await repo.appendAtomic(e2Invalid);
      } catch (e) {
        caught = e;
      }

      // Debe lanzar FormatException desde _applyCollection (splits is! List)
      expect(caught, isA<FormatException>(),
          reason: 'appendAtomic debe lanzar FormatException cuando apply() falla');

      // ── ROLLBACK: E2 NO debe existir en el event store ───────────────────
      final e2Entity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e2Invalid.id)
          .findFirst();
      expect(e2Entity, isNull,
          reason: 'Rollback: AccountingEventEntity de E2 no debe persistir');

      // ── ROLLBACK: outbox de E2 NO debe existir ────────────────────────────
      final e2Outbox = await isar.outboxEventEntitys
          .filter()
          .outboxIdEqualTo('outbox_${e2Invalid.id}')
          .findFirst();
      expect(e2Outbox, isNull,
          reason: 'Rollback: OutboxEventEntity de E2 no debe persistir');

      // ── Proyección sigue reflejando E1 (sin cambios) ─────────────────────
      final projEntity = await isar.accountReceivableProjectionEntitys
          .filter()
          .entityIdEqualTo(entityId)
          .findFirst();
      expect(projEntity, isNotNull,
          reason: 'La proyección de E1 debe seguir existiendo');
      expect(projEntity!.lastEventHash, equals(e1.hash),
          reason: 'Proyección debe apuntar al hash de E1 (sin cambio por rollback)');
      expect(projEntity.saldoActualCop, equals(100000),
          reason: 'Saldo debe ser el mismo que después de E1 (sin cambio)');

      // ── ATOMICITY GUARANTEE ───────────────────────────────────────────────
      // If appendAtomic were not inside a single writeTxn,
      // the event would exist without projection update.
      // This assertion guarantees full rollback atomicity.
      final totalEvents = await isar.accountingEventEntitys
          .filter()
          .entityIdEqualTo(entityId)
          .count();
      expect(totalEvents, equals(1),
          reason: 'Exactamente 1 event entity en store — rollback de E2 confirmado');

      final totalOutboxes = await isar.outboxEventEntitys
          .filter()
          .entityIdEqualTo(entityId)
          .count();
      expect(totalOutboxes, equals(1),
          reason: 'Exactamente 1 outbox en store — rollback de E2 confirmado');
    });
  });

  // ==========================================================================
  // TEST 2 — IDEMPOTENCIA ESTRICTA
  // ==========================================================================

  group('appendAtomic_is_idempotent_same_id_same_hash_and_rejects_hash_collision', () {
    // ── Caso A: re-append del mismo evento es no-op ────────────────────────
    test('Caso A: re-append de evento idéntico es no-op (count=1, seq=1)', () async {
      const entityId = 'AR-T2A';

      final e1 = _event(
        id: 'evt-t2a-001',
        entityId: entityId,
        payload: _initPayload(200000),
        occurredAt: now,
      );

      await repo.appendAtomic(e1);
      await repo.appendAtomic(e1); // no-op: mismo id, mismo hash

      // Solo 1 evento almacenado
      final eventCount = await isar.accountingEventEntitys
          .filter()
          .entityIdEqualTo(entityId)
          .count();
      expect(eventCount, equals(1),
          reason: 'Re-append idéntico no debe crear un segundo event entity');

      // sequenceNumber del único evento = 1
      final storedEntity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e1.id)
          .findFirst();
      expect(storedEntity!.sequenceNumber, equals(1),
          reason: 'sequenceNumber debe ser 1 (solo un evento)');

      // Solo 1 outbox
      final outboxCount = await isar.outboxEventEntitys
          .filter()
          .outboxIdEqualTo('outbox_${e1.id}')
          .count();
      expect(outboxCount, equals(1),
          reason: 'Re-append idéntico no debe crear un segundo outbox');
    });

    // ── Caso B: mismo id, hash distinto → StateError ───────────────────────
    test('Caso B: mismo id con payload distinto (hash diferente) lanza StateError',
        () async {
      const entityId = 'AR-T2B';

      final e1 = _event(
        id: 'evt-t2b-001',
        entityId: entityId,
        payload: _initPayload(150000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      // Mismo id, actorId distinto → hash diferente (firma canónica cambia)
      final e1Collision = AccountingEvent(
        id: e1.id,
        entityType: e1.entityType,
        entityId: e1.entityId,
        eventType: e1.eventType,
        occurredAt: e1.occurredAt,
        recordedAt: e1.recordedAt,
        actorId: 'u_impostor', // diferente → hash diferente
        payload: Map<String, dynamic>.from(e1.payload),
        prevHash: e1.prevHash,
      );

      // Pre-condición: los hashes deben ser distintos
      expect(e1.hash, isNot(equals(e1Collision.hash)),
          reason: 'Pre-condición: hashes deben diferir para simular colisión');

      StateError? caught;
      try {
        await repo.appendAtomic(e1Collision);
      } on StateError catch (e) {
        caught = e;
      }

      expect(caught, isNotNull,
          reason: 'Debe lanzar StateError ante colisión de id con hash distinto');
      expect(caught!.message, contains('collision'),
          reason: 'El mensaje debe mencionar "collision"');

      // Sigue habiendo solo 1 evento y 1 outbox (el original)
      final eventCount = await isar.accountingEventEntitys
          .filter()
          .entityIdEqualTo(entityId)
          .count();
      expect(eventCount, equals(1),
          reason: 'No debe haberse creado un segundo event entity');

      final outboxCount = await isar.outboxEventEntitys
          .filter()
          .entityIdEqualTo(entityId)
          .count();
      expect(outboxCount, equals(1),
          reason: 'No debe haberse creado un outbox extra');
    });
  });

  // ==========================================================================
  // TEST 3 — CHAIN + GAP DETECTION
  // ==========================================================================
  //
  // Escenario principal:
  //   E1 (seq=1) → E2 (seq=2) → borrar E2 → intentar E3 con prevHash=E2.hash
  //   → lastEntity=E1, E3.prevHash=E2.hash ≠ E1.hash → "Hash chain broken"
  //
  // Subcaso:
  //   E2_badPrev con prevHash arbitrario incorrecto → misma excepción.

  group('appendAtomic_enforces_prevHash_and_detects_sequence_gaps', () {
    test('rechaza evento cuando prevHash apunta a evento eliminado (cadena rota)',
        () async {
      const entityId = 'AR-T3';

      final e1 = _event(
        id: 'evt-t3-001',
        entityId: entityId,
        payload: _initPayload(90000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      final e2 = _event(
        id: 'evt-t3-002',
        entityId: entityId,
        payload: _collectPayload(saldoAnterior: 90000, montoCop: 20000),
        occurredAt: now.add(const Duration(seconds: 1)),
        prevHash: e1.hash,
      );
      await repo.appendAtomic(e2);

      // Eliminar E2 manualmente: simula corrupción o borrado fuera de banda
      await isar.writeTxn(() async {
        final entity = await isar.accountingEventEntitys
            .filter()
            .eventIdEqualTo(e2.id)
            .findFirst();
        if (entity != null) {
          await isar.accountingEventEntitys.delete(entity.id);
        }
      });

      // E3 referencia E2 (eliminado): chain rota
      // lastEntity devuelto = E1, pero E3.prevHash = E2.hash ≠ E1.hash
      final e3 = _event(
        id: 'evt-t3-003',
        entityId: entityId,
        payload: _collectPayload(saldoAnterior: 70000, montoCop: 10000),
        occurredAt: now.add(const Duration(seconds: 2)),
        prevHash: e2.hash, // E2 ya no existe: cadena rota
      );

      StateError? caught;
      try {
        await repo.appendAtomic(e3);
      } on StateError catch (e) {
        caught = e;
      }

      expect(caught, isNotNull,
          reason: 'Debe lanzar StateError: Hash chain broken');
      expect(caught!.message, contains('Hash chain broken'),
          reason: 'El mensaje debe indicar ruptura de cadena');

      // E3 no debe persistir
      final e3Entity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e3.id)
          .findFirst();
      expect(e3Entity, isNull, reason: 'E3 no debe existir en el event store');

      // Sin outbox para E3
      final e3Outbox = await isar.outboxEventEntitys
          .filter()
          .outboxIdEqualTo('outbox_${e3.id}')
          .findFirst();
      expect(e3Outbox, isNull, reason: 'No debe crearse outbox para E3');
    });

    test('subcaso: prevHash incorrecto (sin borrar nada) lanza StateError', () async {
      const entityId = 'AR-T3B';

      final e1 = _event(
        id: 'evt-t3b-001',
        entityId: entityId,
        payload: _initPayload(60000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      // E2 con prevHash que no es e1.hash
      final e2BadPrev = _event(
        id: 'evt-t3b-002',
        entityId: entityId,
        payload: _collectPayload(saldoAnterior: 60000, montoCop: 5000),
        occurredAt: now.add(const Duration(seconds: 1)),
        prevHash: 'hash_incorrecto_000000000000000000000000000000000000000000',
      );

      StateError? caught;
      try {
        await repo.appendAtomic(e2BadPrev);
      } on StateError catch (e) {
        caught = e;
      }

      expect(caught, isNotNull,
          reason: 'Debe lanzar StateError: prevHash inválido');
      expect(caught!.message, contains('Hash chain broken'),
          reason: 'El mensaje debe indicar ruptura de cadena');

      // E2_badPrev no debe persistir
      final e2Entity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e2BadPrev.id)
          .findFirst();
      expect(e2Entity, isNull,
          reason: 'E2_badPrev no debe existir en el event store');
    });

    test('gap detection: lanza StateError cuando faltan eventos intermedios en la cadena',
        () async {
      const entityId = 'AR-T3C';

      final e1 = _event(
        id: 'evt-t3c-001',
        entityId: entityId,
        payload: _initPayload(80000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      final e2 = _event(
        id: 'evt-t3c-002',
        entityId: entityId,
        payload: _collectPayload(saldoAnterior: 80000, montoCop: 10000),
        occurredAt: now.add(const Duration(seconds: 1)),
        prevHash: e1.hash,
      );
      await repo.appendAtomic(e2);

      final e3 = _event(
        id: 'evt-t3c-003',
        entityId: entityId,
        payload: _collectPayload(saldoAnterior: 70000, montoCop: 10000),
        occurredAt: now.add(const Duration(seconds: 2)),
        prevHash: e2.hash,
      );
      await repo.appendAtomic(e3);

      // Eliminar E2 (evento intermedio): gap entre seq=1 y seq=3
      await isar.writeTxn(() async {
        final entity = await isar.accountingEventEntitys
            .filter()
            .eventIdEqualTo(e2.id)
            .findFirst();
        if (entity != null) {
          await isar.accountingEventEntitys.delete(entity.id);
        }
      });

      // E4: last event en DB = E3 (seq=3), count real = 2 → gap detectado
      final e4 = _event(
        id: 'evt-t3c-004',
        entityId: entityId,
        payload: _collectPayload(saldoAnterior: 60000, montoCop: 5000),
        occurredAt: now.add(const Duration(seconds: 3)),
        prevHash: e3.hash, // prevHash correcto → pasa chain check
      );

      StateError? caught;
      try {
        await repo.appendAtomic(e4);
      } on StateError catch (e) {
        caught = e;
      }

      expect(caught, isNotNull,
          reason: 'Debe lanzar StateError: gap detection');
      expect(caught!.message, contains('gap'),
          reason: 'El mensaje debe indicar detección de hueco (gap)');

      // E4 no debe persistir
      final e4Entity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e4.id)
          .findFirst();
      expect(e4Entity, isNull, reason: 'E4 no debe existir tras gap detection');
    });
  });

  // ==========================================================================
  // TEST 4 — OUTBOX IDEMPOTENCY KEY
  // ==========================================================================

  group('appendAtomic_sets_outbox_idempotencyKey_equals_event_hash', () {
    test('outbox tiene idempotencyKey=event.hash, status=pending, y timestamps UTC válidos',
        () async {
      const entityId = 'AR-T4';

      final e1 = _event(
        id: 'evt-t4-001',
        entityId: entityId,
        payload: _initPayload(50000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      // Leer OutboxEventEntity directamente desde Isar
      final outbox = await isar.outboxEventEntitys
          .filter()
          .outboxIdEqualTo('outbox_${e1.id}')
          .findFirst();

      expect(outbox, isNotNull, reason: 'OutboxEventEntity debe existir');

      // idempotencyKey debe ser exactamente el hash del evento
      expect(outbox!.idempotencyKey, equals(e1.hash),
          reason: 'idempotencyKey debe ser igual a event.hash');

      // Estado inicial
      expect(outbox.statusWire, equals('pending'),
          reason: 'statusWire inicial debe ser "pending"');
      expect(outbox.retryCount, equals(0),
          reason: 'retryCount inicial debe ser 0');

      // Routing fields
      expect(outbox.eventId, equals(e1.id),
          reason: 'eventId debe coincidir con el evento');
      expect(outbox.entityId, equals(e1.entityId),
          reason: 'entityId debe coincidir con la entidad');
      expect(outbox.entityType, equals(e1.entityType),
          reason: 'entityType debe coincidir con la entidad');

      // Timestamps: parseables y en UTC
      final createdAt = DateTime.tryParse(outbox.createdAtIso);
      final updatedAt = DateTime.tryParse(outbox.updatedAtIso);

      expect(createdAt, isNotNull,
          reason: 'createdAtIso debe ser ISO8601 parseable');
      expect(updatedAt, isNotNull,
          reason: 'updatedAtIso debe ser ISO8601 parseable');
      expect(createdAt!.isUtc, isTrue,
          reason: 'createdAt debe estar en UTC');
      expect(updatedAt!.isUtc, isTrue,
          reason: 'updatedAt debe estar en UTC');

      // No debe tener lock ni error inicial
      expect(outbox.workerLockedBy, isNull,
          reason: 'workerLockedBy debe ser null al crear');
      expect(outbox.lockedUntilIso, isNull,
          reason: 'lockedUntilIso debe ser null al crear');
      expect(outbox.lastError, isNull,
          reason: 'lastError debe ser null al crear');
    });
  });

  // ==========================================================================
  // TEST 6 — HASH TAMPER DETECTION (ANTI-FRAUDE EN REPOSO)
  // ==========================================================================
  //
  // Escenario:
  // - E1 se almacena correctamente.
  // - Se abre writeTxn manual y se modifica payloadJson SIN modificar hash.
  // - Al leer con getById(), verifiedFromJson() recomputa el hash desde el
  //   payload modificado → no coincide con el hash almacenado → FormatException.
  //
  // Valida: verifiedFromJson protege contra corrupción física y fraude intencional.

  group('event_entity_detects_payload_tampering_on_decode', () {
    test(
        'getById lanza FormatException cuando payloadJson es modificado sin actualizar hash',
        () async {
      const entityId = 'AR-T6';

      final e1 = _event(
        id: 'evt-t6-001',
        entityId: entityId,
        payload: _initPayload(100000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      // ── TAMPER: modificar payloadJson en disco sin tocar el campo hash ────
      await isar.writeTxn(() async {
        final entity = await isar.accountingEventEntitys
            .filter()
            .eventIdEqualTo(e1.id)
            .findFirst();

        expect(entity, isNotNull, reason: 'Pre-condición: entidad debe existir');

        // Decodificar, alterar un valor, re-codificar
        final tampered =
            Map<String, dynamic>.from(jsonDecode(entity!.payloadJson) as Map);
        tampered['saldoInicialCop'] = 1; // valor manipulado

        entity.payloadJson = jsonEncode(tampered);
        // entity.hash NO se modifica → el checksum ya no corresponde al payload

        await isar.accountingEventEntitys.put(entity);
      });

      // ── DETECCIÓN: leer a través del repositorio debe fallar ──────────────
      FormatException? caught;
      try {
        await repo.getById(e1.id);
      } on FormatException catch (e) {
        caught = e;
      }

      expect(caught, isNotNull,
          reason:
              'getById debe lanzar FormatException — hash mismatch detectado');
      expect(caught!.message, contains('hash mismatch'),
          reason: 'El mensaje debe indicar "hash mismatch"');
    });

    test('accountingEventFromEntity lanza FormatException en lectura directa con payload alterado',
        () async {
      const entityId = 'AR-T6B';

      final e1 = _event(
        id: 'evt-t6b-001',
        entityId: entityId,
        payload: _initPayload(50000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      // Recuperar entidad y alterar payload
      final entity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e1.id)
          .findFirst();

      expect(entity, isNotNull);

      final tampered =
          Map<String, dynamic>.from(jsonDecode(entity!.payloadJson) as Map);
      tampered['totalIngresadoCop'] = 9999999; // valor inyectado
      entity.payloadJson = jsonEncode(tampered);
      // hash intacto → mismatch garantizado

      // accountingEventFromEntity llama verifiedFromJson internamente
      FormatException? caught;
      try {
        accountingEventFromEntity(entity);
      } on FormatException catch (e) {
        caught = e;
      }

      expect(caught, isNotNull,
          reason: 'accountingEventFromEntity debe lanzar FormatException');
      expect(caught!.message, contains('hash mismatch'),
          reason: 'El mensaje debe indicar "hash mismatch"');
    });
  });

  // ==========================================================================
  // TEST 7 — PAYLOAD CHECKSUM (payloadHash en reposo)
  // ==========================================================================
  //
  // Valida que la entidad Isar almacena un SHA-256 del payloadJson en el campo
  // payloadHash. Este checksum es independiente del hash del evento (que cubre
  // todos los campos) y permite detectar corrupción de disco en reposo.

  group('accounting_event_entity_stores_correct_payloadHash_checksum', () {
    test('entity.payloadHash == SHA-256(payloadJson) para evento de inicialización',
        () async {
      const entityId = 'AR-T7';

      final e1 = _event(
        id: 'evt-t7-001',
        entityId: entityId,
        payload: _initPayload(75000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      // Leer entidad directamente (sin pasar por verifiedFromJson)
      final entity = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e1.id)
          .findFirst();

      expect(entity, isNotNull, reason: 'La entidad debe existir');

      // Recomputar SHA-256 del payloadJson almacenado
      final expectedHash =
          sha256.convert(utf8.encode(entity!.payloadJson)).toString();

      expect(entity.payloadHash, equals(expectedHash),
          reason: 'payloadHash debe ser SHA-256 del payloadJson persistido');

      // Invariantes del digest SHA-256 hex
      expect(entity.payloadHash, isNotEmpty,
          reason: 'payloadHash no debe estar vacío');
      expect(entity.payloadHash.length, equals(64),
          reason: 'SHA-256 hex digest debe tener 64 caracteres');
    });

    test('payloadHash difiere entre dos eventos con payloads distintos', () async {
      const entityId = 'AR-T7B';

      final e1 = _event(
        id: 'evt-t7b-001',
        entityId: entityId,
        payload: _initPayload(100000),
        occurredAt: now,
      );
      await repo.appendAtomic(e1);

      final e2 = _event(
        id: 'evt-t7b-002',
        entityId: entityId,
        payload: _collectPayload(saldoAnterior: 100000, montoCop: 30000),
        occurredAt: now.add(const Duration(seconds: 1)),
        prevHash: e1.hash,
      );
      await repo.appendAtomic(e2);

      final ent1 = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e1.id)
          .findFirst();
      final ent2 = await isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(e2.id)
          .findFirst();

      expect(ent1, isNotNull);
      expect(ent2, isNotNull);

      // Payloads distintos → payloadHash distintos
      expect(ent1!.payloadHash, isNot(equals(ent2!.payloadHash)),
          reason: 'Eventos con payloads distintos deben tener payloadHash distintos');

      // Verificar consistencia individual de cada uno
      expect(ent1.payloadHash,
          equals(sha256.convert(utf8.encode(ent1.payloadJson)).toString()));
      expect(ent2.payloadHash,
          equals(sha256.convert(utf8.encode(ent2.payloadJson)).toString()));
    });
  });
}

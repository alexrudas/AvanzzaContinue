// ============================================================================
// test/infrastructure/isar/entities/accounting_wire_compatibility_test.dart
// Compatibilidad con datos legacy: los bytes persistidos en Isar hoy
// ('pending'|'synced'|'error' y 'abierta'|'cerrada'|'ajustada') deben seguir
// leyéndose y escribiéndose EXACTAMENTE iguales tras el refactor a codecs.
//
// Este test es el contrato anti-regresión: congelar spelling, casing e idioma.
// ============================================================================

import 'package:avanzza/domain/entities/accounting/account_receivable_projection.dart';
import 'package:avanzza/domain/entities/accounting/outbox_event.dart';
import 'package:avanzza/infrastructure/isar/entities/account_receivable_projection_entity.dart';
import 'package:avanzza/infrastructure/isar/entities/outbox_event_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // OUTBOX
  // ───────────────────────────────────────────────────────────────────────────
  group('OutboxEvent ↔ OutboxEventEntity (wire legacy)', () {
    final createdAt = DateTime.utc(2026, 4, 18, 10, 0, 0);
    final updatedAt = DateTime.utc(2026, 4, 18, 10, 5, 0);

    OutboxEvent makeDomain(OutboxStatus status) => OutboxEvent(
          id: 'outbox-123',
          eventId: 'evt-abc',
          entityType: 'account_receivable',
          entityId: 'AR-1',
          status: status,
          retryCount: 0,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

    test('domain(pending) → entity.statusWire = "pending" EXACTO', () {
      final e = outboxEventToEntity(makeDomain(OutboxStatus.pending));
      expect(e.statusWire, 'pending');
    });

    test('domain(synced) → entity.statusWire = "synced" EXACTO', () {
      final e = outboxEventToEntity(makeDomain(OutboxStatus.synced));
      expect(e.statusWire, 'synced');
    });

    test('domain(error) → entity.statusWire = "error" EXACTO', () {
      final e = outboxEventToEntity(makeDomain(OutboxStatus.error));
      expect(e.statusWire, 'error');
    });

    test('round-trip domain → entity → domain preserva status', () {
      for (final s in OutboxStatus.values) {
        final back = outboxEventFromEntity(outboxEventToEntity(makeDomain(s)));
        expect(back.status, s);
      }
    });

    test('entity legacy (statusWire="pending") → domain.status=pending', () {
      final entity = OutboxEventEntity()
        ..outboxId = 'outbox-legacy'
        ..eventId = 'evt-legacy'
        ..entityType = 'account_receivable'
        ..entityId = 'AR-L'
        ..statusWire = 'pending' // string legacy ya persistido
        ..retryCount = 0
        ..createdAtIso = createdAt.toIso8601String()
        ..updatedAtIso = updatedAt.toIso8601String();

      final back = outboxEventFromEntity(entity);
      expect(back.status, OutboxStatus.pending);
    });

    test('entity legacy con statusWire corrupto → FormatException', () {
      final entity = OutboxEventEntity()
        ..outboxId = 'outbox-corrupt'
        ..eventId = 'evt-corrupt'
        ..entityType = 'account_receivable'
        ..entityId = 'AR-C'
        ..statusWire = 'PENDING' // casing distinto = corrupción
        ..retryCount = 0
        ..createdAtIso = createdAt.toIso8601String()
        ..updatedAtIso = updatedAt.toIso8601String();

      expect(() => outboxEventFromEntity(entity), throwsFormatException);
    });

    test('entity con statusWire vacío → FormatException (sin fallback)', () {
      final entity = OutboxEventEntity()
        ..outboxId = 'outbox-empty'
        ..eventId = 'evt-empty'
        ..entityType = 'account_receivable'
        ..entityId = 'AR-E'
        ..statusWire = ''
        ..retryCount = 0
        ..createdAtIso = createdAt.toIso8601String()
        ..updatedAtIso = updatedAt.toIso8601String();

      expect(() => outboxEventFromEntity(entity), throwsFormatException);
    });

    test('entity.statusEnum delega al codec y preserva semántica', () {
      final entity = OutboxEventEntity()
        ..outboxId = 'ob-x'
        ..eventId = 'ev-x'
        ..entityType = 'account_receivable'
        ..entityId = 'AR-X'
        ..statusWire = 'synced'
        ..retryCount = 0
        ..createdAtIso = createdAt.toIso8601String()
        ..updatedAtIso = updatedAt.toIso8601String();
      expect(entity.statusEnum, OutboxStatus.synced);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // AR PROJECTION
  // ───────────────────────────────────────────────────────────────────────────
  group('ARProjection ↔ ARProjectionEntity (wire legacy)', () {
    final updatedAt = DateTime.utc(2026, 4, 18, 11, 0, 0);

    AccountReceivableProjection makeDomain(ARProjectionEstado estado) =>
        AccountReceivableProjection(
          entityId: 'AR-100',
          saldoActualCop: 1000,
          totalRecaudadoCop: 0,
          estado: estado,
          lastEventHash: null,
          updatedAt: updatedAt,
        );

    test('domain(abierta) → entity.estadoWire = "abierta" EXACTO', () {
      final e = projectionToEntity(makeDomain(ARProjectionEstado.abierta));
      expect(e.estadoWire, 'abierta');
    });

    test('domain(cerrada) → entity.estadoWire = "cerrada" EXACTO', () {
      final e = projectionToEntity(makeDomain(ARProjectionEstado.cerrada));
      expect(e.estadoWire, 'cerrada');
    });

    test('domain(ajustada) → entity.estadoWire = "ajustada" EXACTO', () {
      final e = projectionToEntity(makeDomain(ARProjectionEstado.ajustada));
      expect(e.estadoWire, 'ajustada');
    });

    test('round-trip domain → entity → domain preserva estado', () {
      for (final s in ARProjectionEstado.values) {
        final back =
            projectionFromEntity(projectionToEntity(makeDomain(s)));
        expect(back.estado, s);
      }
    });

    test(
        'entity legacy (estadoWire="abierta") → domain.estado=abierta',
        () {
      final entity = AccountReceivableProjectionEntity()
        ..entityId = 'AR-legacy'
        ..saldoActualCop = 500
        ..totalRecaudadoCop = 0
        ..estadoWire = 'abierta'
        ..lastEventHash = null
        ..updatedAtIso = updatedAt.toIso8601String();

      final back = projectionFromEntity(entity);
      expect(back.estado, ARProjectionEstado.abierta);
    });

    test('entity con estadoWire corrupto → FormatException', () {
      final entity = AccountReceivableProjectionEntity()
        ..entityId = 'AR-corrupt'
        ..saldoActualCop = 0
        ..totalRecaudadoCop = 0
        ..estadoWire = 'ABIERTA' // casing distinto
        ..lastEventHash = null
        ..updatedAtIso = updatedAt.toIso8601String();

      expect(() => projectionFromEntity(entity), throwsFormatException);
    });

    test('entity con estadoWire vacío → FormatException (sin fallback)', () {
      final entity = AccountReceivableProjectionEntity()
        ..entityId = 'AR-empty'
        ..saldoActualCop = 0
        ..totalRecaudadoCop = 0
        ..estadoWire = ''
        ..lastEventHash = null
        ..updatedAtIso = updatedAt.toIso8601String();

      expect(() => projectionFromEntity(entity), throwsFormatException);
    });

    test('entity.estadoEnum delega al codec y preserva semántica', () {
      final entity = AccountReceivableProjectionEntity()
        ..entityId = 'AR-x'
        ..saldoActualCop = 0
        ..totalRecaudadoCop = 0
        ..estadoWire = 'cerrada'
        ..lastEventHash = null
        ..updatedAtIso = updatedAt.toIso8601String();
      expect(entity.estadoEnum, ARProjectionEstado.cerrada);
    });
  });
}

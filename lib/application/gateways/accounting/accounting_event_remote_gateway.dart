// ============================================================================
// lib/application/gateways/accounting/accounting_event_remote_gateway.dart
// REMOTE GATEWAY — Enterprise Ultra Pro (Application Layer)
//
// QUÉ HACE:
// - Define el contrato AccountingEventRemoteGateway para ingestión batch.
// - Provee implementación Fake configurable (dev / offline-first / testing).
//
// QUÉ NO HACE:
// - NO persiste datos (eso es responsabilidad del repositorio).
// - NO maneja reintentos (eso es responsabilidad del Sync Service).
// - NO recalcula reglas contables.
// - NO recibe idempotencyKey aparte: lo deriva de event.hash.
//
// PRINCIPIOS:
// - idempotencyKey = event.hash (SHA-256 canonical del dominio).
// - El orden del batch es responsabilidad del worker (sequenceNumber).
// - En error de red/servidor → throw Exception (fail-fast).
//
// ENTERPRISE NOTES:
// - FakeGateway soporta modos: alwaysOk / flaky / alwaysFail / failOncePerBatch.
// - Permite simular latencia realista.
// - Permite validar robustez del worker (backoff, retry, lease).
// ============================================================================

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/accounting/accounting_event.dart';

/// ============================================================================
/// RESULT
/// ============================================================================

class RemoteIngestResult {
  RemoteIngestResult({
    required this.acceptedEventIds,
    required this.ignoredAsDuplicateEventIds,
  });

  /// IDs aceptados como nuevos en backend.
  final List<String> acceptedEventIds;

  /// IDs ignorados por idempotencia (ya existían).
  final List<String> ignoredAsDuplicateEventIds;
}

/// ============================================================================
/// CONTRACT
/// ============================================================================

abstract class AccountingEventRemoteGateway {
  /// Envía un batch de eventos al backend.
  ///
  /// Reglas:
  /// - idempotencyKey = event.hash (derivado internamente).
  /// - Los eventos llegan ya ordenados por sequenceNumber.
  /// - Debe throw Exception en error de red o servidor.
  Future<RemoteIngestResult> ingestBatch(List<AccountingEvent> events);
}

/// ============================================================================
/// FAKE IMPLEMENTATION — ENTERPRISE GRADE
/// ============================================================================

enum FakeGatewayMode {
  alwaysOk,
  flaky,
  alwaysFail,
  failOncePerBatch,
}

class FakeAccountingEventRemoteGateway implements AccountingEventRemoteGateway {
  FakeAccountingEventRemoteGateway({
    this.mode = FakeGatewayMode.alwaysOk,
    this.minLatencyMs = 150,
    this.maxLatencyMs = 400,
    Random? random,
  })  : _random = random ?? Random(),
        assert(minLatencyMs >= 0),
        assert(maxLatencyMs >= minLatencyMs);

  final FakeGatewayMode mode;
  final int minLatencyMs;
  final int maxLatencyMs;
  final Random _random;

  bool _hasFailedOnce = false;

  @override
  Future<RemoteIngestResult> ingestBatch(List<AccountingEvent> events) async {
    _preflightValidate(events);

    if (kDebugMode) {
      final sample = events.isNotEmpty ? events.first.id : 'N/A';
      debugPrint(
        '[P2D][Outbox][Gateway][Ingest] received=${events.length} '
        'sampleEventId=$sample',
      );
    }

    // Simular latencia realista
    final latency =
        minLatencyMs + _random.nextInt(maxLatencyMs - minLatencyMs + 1);

    await Future.delayed(Duration(milliseconds: latency));

    switch (mode) {
      case FakeGatewayMode.alwaysOk:
        return _success(events);

      case FakeGatewayMode.alwaysFail:
        throw Exception('FakeGateway: simulated permanent failure');

      case FakeGatewayMode.failOncePerBatch:
        if (!_hasFailedOnce) {
          _hasFailedOnce = true;
          throw Exception('FakeGateway: simulated one-time failure');
        }
        return _success(events);

      case FakeGatewayMode.flaky:
        final dice = _random.nextDouble();
        if (dice < 0.3) {
          throw Exception('FakeGateway: simulated flaky failure');
        }
        return _success(events);
    }
  }

  /// =========================================================================
  /// PRIVATE HELPERS
  /// =========================================================================

  RemoteIngestResult _success(List<AccountingEvent> events) {
    final result = RemoteIngestResult(
      acceptedEventIds: events.map((e) => e.id).toList(),
      ignoredAsDuplicateEventIds: const [],
    );
    if (kDebugMode) {
      debugPrint(
        '[P2D][Outbox][Gateway][Result] accepted=${result.acceptedEventIds.length} '
        'duplicates=${result.ignoredAsDuplicateEventIds.length}',
      );
    }
    return result;
  }

  void _preflightValidate(List<AccountingEvent> events) {
    if (events.isEmpty) {
      throw ArgumentError('ingestBatch: events list cannot be empty');
    }

    for (final e in events) {
      if (e.id.isEmpty) {
        throw ArgumentError('ingestBatch: event.id cannot be empty');
      }
      if (e.entityId.isEmpty) {
        throw ArgumentError('ingestBatch: event.entityId cannot be empty');
      }
      if (e.entityType.isEmpty) {
        throw ArgumentError('ingestBatch: event.entityType cannot be empty');
      }
      if (e.eventType.isEmpty) {
        throw ArgumentError('ingestBatch: event.eventType cannot be empty');
      }
      if (e.hash.isEmpty) {
        throw ArgumentError('ingestBatch: event.hash cannot be empty');
      }
    }
  }
}

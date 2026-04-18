// ============================================================================
// lib/domain/entities/accounting/account_receivable_projection.dart
// AUDIT TRAIL — Enterprise Ultra Pro (Domain)
//
// QUÉ HACE:
// - Proyección CQRS inmutable del estado de una CxC reconstruida desde eventos.
// - Única puerta de aplicación de eventos: apply(AccountingEvent event).
// - Estado "ajustada" es IRREVERSIBLE salvo evento explícito de reversión.
// - Fail-fast ante cualquier inconsistencia.
//
// QUÉ NO HACE:
// - NO persiste datos.
// - NO depende de Flutter ni GetX.
// - NO usa double.
// - NO expone mapping enum ↔ string (DOMAIN_CONTRACTS.md v1.1.3 §C). El
//   mapping canónico de `ARProjectionEstado` ↔ persistencia vive únicamente
//   en `infrastructure/isar/codecs/ar_projection_estado_codec.dart`.
// - NO define toJson/fromJson: sin callers vivos; la serialización hoy pasa
//   por los mappers Isar dedicados. Reintroducirla aquí duplicaría el
//   mapping enum ↔ string.
//
// CONTRATO DE PAYLOAD (alineado a P2-B):
//
// eventType: "ar_collection_recorded"
// {
//   "splits": List<Map> (requerido)
//     cada split:
//       "montoCop": int (>=0)
//   "saldoInicialCop": int (requerido)
//   "totalIngresadoCop": int (requerido)
//   "diferenciaCop": int (requerido)
//   "saldoFinalCop": int (requerido)
// }
//
// eventType: "ar_adjustment_applied"
// {
//   "valorAjusteCop": int (requerido, >0)
//   "saldoFinalCop": int (requerido)
// }
//
// INVARIANTES:
// - saldoActualCop >= 0
// - totalRecaudadoCop >= 0
// - No se permiten underflows.
// - Estado ajustada es irreversible sin evento explícito.
// ============================================================================

import 'accounting_event.dart';

// ---------------------------------------------------------------------------
// ENUM ESTADO
// ---------------------------------------------------------------------------

enum ARProjectionEstado {
  abierta,
  cerrada,
  ajustada,
}

// ---------------------------------------------------------------------------
// PROYECCIÓN
// ---------------------------------------------------------------------------

class AccountReceivableProjection {
  AccountReceivableProjection({
    required this.entityId,
    required this.saldoActualCop,
    required this.totalRecaudadoCop,
    required this.estado,
    required this.lastEventHash,
    required this.updatedAt,
  })  : assert(entityId.isNotEmpty),
        assert(saldoActualCop >= 0),
        assert(totalRecaudadoCop >= 0);

  final String entityId;
  final int saldoActualCop;
  final int totalRecaudadoCop;
  final ARProjectionEstado estado;
  final String? lastEventHash;
  final DateTime updatedAt;

  // ===========================================================================
  // ENTRY POINT ÚNICO
  // ===========================================================================

  AccountReceivableProjection apply(AccountingEvent event) {
    switch (event.eventType) {
      case 'ar_collection_recorded':
        return _applyCollection(event);
      case 'ar_adjustment_applied':
        return _applyAdjustment(event);
      default:
        throw ArgumentError(
          'Unsupported eventType for ARProjection: ${event.eventType}',
        );
    }
  }

  // ===========================================================================
  // COLLECTION
  // ===========================================================================

  AccountReceivableProjection _applyCollection(AccountingEvent event) {
    final payload = event.payload;

    final splits = payload['splits'];
    final totalIngresado = payload['totalIngresadoCop'];
    final saldoFinalPayload = payload['saldoFinalCop'];

    if (splits is! List) {
      throw const FormatException('splits must be List');
    }
    if (totalIngresado is! int || saldoFinalPayload is! int) {
      throw const FormatException(
          'Invalid numeric payload in collection event');
    }

    final sumSplits = splits.fold<int>(0, (sum, e) {
      if (e is! Map) throw const FormatException('Invalid split entry');
      final monto = e['montoCop'];
      if (monto is! int || monto < 0) {
        throw const FormatException('Invalid montoCop in split');
      }
      return sum + monto;
    });

    if (sumSplits != totalIngresado) {
      throw StateError('Split sum mismatch with totalIngresadoCop');
    }

    final rawSaldo = saldoActualCop - totalIngresado;

    if (rawSaldo < 0) {
      throw StateError('Projection underflow detected (collection)');
    }

    if (rawSaldo != saldoFinalPayload) {
      throw StateError('saldoFinalCop mismatch with computed saldo');
    }

    final nuevoEstado = _resolveEstado(
      saldoFinal: rawSaldo,
      incomingAdjustment: false,
    );

    return copyWith(
      saldoActualCop: rawSaldo,
      totalRecaudadoCop: totalRecaudadoCop + totalIngresado,
      estado: nuevoEstado,
      lastEventHash: event.hash,
      updatedAt: event.occurredAt,
    );
  }

  // ===========================================================================
  // ADJUSTMENT
  // ===========================================================================

  AccountReceivableProjection _applyAdjustment(AccountingEvent event) {
    final payload = event.payload;

    final valorAjuste = payload['valorAjusteCop'];
    final saldoFinalPayload = payload['saldoFinalCop'];

    if (valorAjuste is! int || valorAjuste <= 0) {
      throw const FormatException('Invalid valorAjusteCop');
    }
    if (saldoFinalPayload is! int) {
      throw const FormatException('Invalid saldoFinalCop');
    }

    final rawSaldo = saldoActualCop - valorAjuste;

    if (rawSaldo < 0) {
      throw StateError('Projection underflow detected (adjustment)');
    }

    if (rawSaldo != saldoFinalPayload) {
      throw StateError('saldoFinalCop mismatch after adjustment');
    }

    return copyWith(
      saldoActualCop: rawSaldo,
      estado: rawSaldo == 0
          ? ARProjectionEstado.ajustada
          : ARProjectionEstado.abierta,
      lastEventHash: event.hash,
      updatedAt: event.occurredAt,
    );
  }

  // ===========================================================================
  // ESTADO RESOLVER (AJUSTADA IRREVERSIBLE)
  // ===========================================================================

  ARProjectionEstado _resolveEstado({
    required int saldoFinal,
    required bool incomingAdjustment,
  }) {
    // IRREVERSIBILIDAD:
    // Si ya fue ajustada en el pasado, se mantiene ajustada.
    if (estado == ARProjectionEstado.ajustada) {
      return ARProjectionEstado.ajustada;
    }

    if (saldoFinal > 0) {
      return ARProjectionEstado.abierta;
    }

    if (incomingAdjustment) {
      return ARProjectionEstado.ajustada;
    }

    return ARProjectionEstado.cerrada;
  }

  // ===========================================================================
  // COPY
  // ===========================================================================

  AccountReceivableProjection copyWith({
    int? saldoActualCop,
    int? totalRecaudadoCop,
    ARProjectionEstado? estado,
    String? lastEventHash,
    DateTime? updatedAt,
  }) {
    return AccountReceivableProjection(
      entityId: entityId,
      saldoActualCop: saldoActualCop ?? this.saldoActualCop,
      totalRecaudadoCop: totalRecaudadoCop ?? this.totalRecaudadoCop,
      estado: estado ?? this.estado,
      lastEventHash: lastEventHash ?? this.lastEventHash,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

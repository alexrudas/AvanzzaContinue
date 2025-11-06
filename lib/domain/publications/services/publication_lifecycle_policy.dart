/*
Servicio de dominio para transiciones de estado en publicaciones.
Dominio puro: sin dependencias de UI ni async.

Uso:
- Valida transiciones según grafo de estados.
- Aplica reglas de negocio (créditos, idempotencia).
- Devuelve Result tipado para manejo de errores.
*/

import '../value_objects/publication_status.dart';

/// Resultado sellado de transición de estado.
sealed class LifecycleResult {
  const LifecycleResult();
}

/// Transición exitosa con datos de auditoría.
class LifecycleSuccess extends LifecycleResult {
  final PublicationStatus from;
  final PublicationStatus to;
  final PublicationTransitionReason reason;
  final DateTime processedAtUtc;
  final Map<String, Object?> audit;

  const LifecycleSuccess({
    required this.from,
    required this.to,
    required this.reason,
    required this.processedAtUtc,
    this.audit = const {},
  });
}

/// Transición fallida con código y metadata.
class LifecycleFailure extends LifecycleResult {
  final String code;
  final String message;
  final Map<String, Object?> metadata;

  const LifecycleFailure(
    this.code,
    this.message, {
    this.metadata = const {},
  });
}

/// Contrato mínimo para políticas de plan/créditos.
/// Implementación concreta en capa de aplicación.
abstract class LifecyclePlanPolicy {
  /// Si el usuario tiene créditos suficientes para renovar.
  bool get hasCredits;

  /// Si el usuario es elegible para usar freeOnce.
  bool get canUseFreeOnce;

  /// Consume créditos necesarios para reactivar desde expired.
  /// Debe ejecutarse en transacción atómica.
  void consumeForRenewal();

  /// Verifica si un requestId ya fue procesado (idempotencia).
  bool isRequestProcessed(String requestId);

  /// Marca un requestId como procesado.
  void markRequestProcessed(String requestId);
}

/// Servicio de dominio para validación y ejecución de transiciones.
class PublicationLifecyclePolicy {
  /// Valida y ejecuta una transición de estado.
  ///
  /// Reglas aplicadas:
  /// 1. Validación del grafo de transiciones permitidas.
  /// 2. Idempotencia mediante requestId.
  /// 3. Reactivación desde pausa: no consume créditos.
  /// 4. Renovación desde expired: requiere planPolicy y créditos o freeOnce.
  /// 5. Expiración automática: permitida con reason=planExpired.
  /// 6. Cierre definitivo: siempre permitido (estado terminal).
  ///
  /// [nowUtc] debe venir del servidor para evitar manipulación del cliente.
  /// [requestId] permite idempotencia ante reintentos.
  /// [planPolicy] requerido solo para expired→active.
  static LifecycleResult transition({
    required PublicationStatus from,
    required PublicationStatus to,
    required PublicationTransitionReason reason,
    required DateTime nowUtc,
    required String requestId,
    LifecyclePlanPolicy? planPolicy,
  }) {
    assert(nowUtc.isUtc, 'nowUtc debe ser UTC');

    /// Regla 1: Validación del grafo de transiciones.
    if (!from.canTransitionTo(to)) {
      return LifecycleFailure(
        'not_allowed',
        'Transición no permitida de ${from.wireName} a ${to.wireName}',
        metadata: {'from': from.wireName, 'to': to.wireName},
      );
    }

    /// Regla 2: Idempotencia - rechazar operaciones duplicadas.
    if (planPolicy != null && planPolicy.isRequestProcessed(requestId)) {
      return LifecycleFailure(
        'duplicate_operation',
        'Operación ya procesada',
        metadata: {'requestId': requestId},
      );
    }

    /// Regla 3: Reactivación desde pausa no consume créditos.
    if (from == PublicationStatus.paused && to == PublicationStatus.active) {
      planPolicy?.markRequestProcessed(requestId);
      return LifecycleSuccess(
        from: from,
        to: to,
        reason: reason,
        processedAtUtc: nowUtc,
        audit: {'requestId': requestId, 'creditsConsumed': 0},
      );
    }

    /// Regla 4: Renovación desde expired requiere planPolicy y créditos.
    if (from == PublicationStatus.expired && to == PublicationStatus.active) {
      if (planPolicy == null) {
        return const LifecycleFailure(
          'policy_missing',
          'Se requiere planPolicy para renovar desde expired',
        );
      }

      if (!(planPolicy.hasCredits || planPolicy.canUseFreeOnce)) {
        return const LifecycleFailure(
          'credits_required',
          'No hay créditos ni freeOnce disponible para renovar',
        );
      }

      /// Efecto: consumir créditos si aplica.
      if (planPolicy.hasCredits) {
        try {
          planPolicy.consumeForRenewal();
        } catch (e) {
          return LifecycleFailure(
            'renewal_transaction_failed',
            'Error al consumir créditos: $e',
          );
        }
      }

      planPolicy.markRequestProcessed(requestId);
      return LifecycleSuccess(
        from: from,
        to: to,
        reason: reason,
        processedAtUtc: nowUtc,
        audit: {'requestId': requestId, 'renewed': true},
      );
    }

    /// Regla 5: Expiración automática permitida.
    if (from == PublicationStatus.active &&
        to == PublicationStatus.expired &&
        reason == PublicationTransitionReason.planExpired) {
      planPolicy?.markRequestProcessed(requestId);
      return LifecycleSuccess(
        from: from,
        to: to,
        reason: reason,
        processedAtUtc: nowUtc,
        audit: {'requestId': requestId, 'automatic': true},
      );
    }

    /// Regla 6: Cierre definitivo siempre permitido (estado terminal).
    if (to == PublicationStatus.closed) {
      planPolicy?.markRequestProcessed(requestId);
      return LifecycleSuccess(
        from: from,
        to: to,
        reason: reason,
        processedAtUtc: nowUtc,
        audit: {'requestId': requestId, 'terminal': true},
      );
    }

    /// Caso por defecto: transición permitida por el grafo.
    planPolicy?.markRequestProcessed(requestId);
    return LifecycleSuccess(
      from: from,
      to: to,
      reason: reason,
      processedAtUtc: nowUtc,
      audit: {'requestId': requestId},
    );
  }
}

/*
Excepciones tipadas para planes de publicación.
Dominio puro: sin dependencias de UI ni DS.

Uso:
- Capturar errores en Application layer y mapear a mensajes i18n.
- En analytics, registra 'code' y 'metadata' para diagnóstico.
*/
// lib/domain/publications/errors/publication_plan_exceptions.dart

/// Excepción base para errores de plan.
/// Incluye código, mensaje y metadatos para auditoría.
abstract class PublicationPlanException implements Exception {
  final String code;
  final String message;
  final Map<String, Object?> metadata;

  const PublicationPlanException(
    this.code,
    this.message, {
    this.metadata = const {},
  });

  @override
  String toString() => 'PublicationPlanException($code): $message';
}

/// El plan no es elegible para activar (freeOnce ya usado o créditos insuficientes).
class PlanNotEligible extends PublicationPlanException {
  const PlanNotEligible({Map<String, Object?> metadata = const {}})
      : super('plan_not_eligible', 'Plan no elegible para activar',
            metadata: metadata);
}

/// El usuario no tiene suficientes créditos.
class InsufficientCredits extends PublicationPlanException {
  InsufficientCredits({required int needed, required int available})
      : super(
          'insufficient_credits',
          'Créditos insuficientes',
          metadata: {'needed': needed, 'available': available},
        );
}

/// El plan no permite renovación (ej: freeOnce).
class NonRenewablePlan extends PublicationPlanException {
  const NonRenewablePlan() : super('non_renewable', 'El plan no es renovable');
}

/// Se alcanzó el límite de renovaciones permitidas.
class RenewalLimitReached extends PublicationPlanException {
  RenewalLimitReached({required int limit, required int used})
      : super(
          'renewal_limit',
          'Límite de renovaciones alcanzado',
          metadata: {'limit': limit, 'used': used},
        );
}

/// La publicación está en un estado que no permite la operación.
class InvalidPublicationState extends PublicationPlanException {
  InvalidPublicationState({required String currentState})
      : super(
          'invalid_state',
          'Estado de publicación no permite la operación',
          metadata: {'currentState': currentState},
        );
}

/// Operación duplicada detectada (idempotencia).
class DuplicateOperation extends PublicationPlanException {
  DuplicateOperation({required String requestId})
      : super(
          'duplicate_operation',
          'Operación ya procesada',
          metadata: {'requestId': requestId},
        );
}

// lib/domain/publications/value_objects/publication_plan.dart
// Dominio puro: sin dependencias de UI ni DS.
//
// IMPORTANTE:
// - Todas las operaciones que consumen créditos requieren transacción atómica en repositorio.
// - nowUtc debe venir del servidor para evitar manipulación del cliente.
// - requestId debe ser ULID o UUID v7 para orden temporal.
// - Expiraciones: N×24h exactas desde createdAtUtc o expireAtUtc vigente (stacking).

/// Planes de publicación con diferentes duraciones, costos y beneficios.
enum PublicationPlan {
  freeOnce, // Una vez gratis por usuario (lifetime)
  starter, // 3 días
  plus, // 7 días + 1 boost
  pro, // 14 días + 2 boosts
}

/// Extensión con metadata de cada plan.
extension PublicationPlanX on PublicationPlan {
  /// Clave i18n estable para el nombre del plan.
  String get displayNameKey {
    switch (this) {
      case PublicationPlan.freeOnce:
        return 'publication.plan.free_once';
      case PublicationPlan.starter:
        return 'publication.plan.starter';
      case PublicationPlan.plus:
        return 'publication.plan.plus';
      case PublicationPlan.pro:
        return 'publication.plan.pro';
    }
  }

  /// Clave i18n para descripción del alcance.
  String get reachDescriptionKey {
    switch (this) {
      case PublicationPlan.freeOnce:
        return 'publication.plan.reach.basic_city';
      case PublicationPlan.starter:
        return 'publication.plan.reach.regional';
      case PublicationPlan.plus:
        return 'publication.plan.reach.multi_city';
      case PublicationPlan.pro:
        return 'publication.plan.reach.national_priority';
    }
  }

  /// Duración en días del plan.
  int get durationDays {
    switch (this) {
      case PublicationPlan.freeOnce:
        return 1;
      case PublicationPlan.starter:
        return 3;
      case PublicationPlan.plus:
        return 7;
      case PublicationPlan.pro:
        return 14;
    }
  }

  /// Costo en créditos.
  int get creditsRequired {
    switch (this) {
      case PublicationPlan.freeOnce:
        return 0;
      case PublicationPlan.starter:
        return 1;
      case PublicationPlan.plus:
        return 2;
      case PublicationPlan.pro:
        return 3;
    }
  }

  /// Número de boosts incluidos en el plan.
  int get boostsIncluded {
    switch (this) {
      case PublicationPlan.freeOnce:
      case PublicationPlan.starter:
        return 0;
      case PublicationPlan.plus:
        return 1;
      case PublicationPlan.pro:
        return 2;
    }
  }

  /// Peso en el algoritmo de discovery (mayor = más visibilidad).
  double get discoveryWeight {
    switch (this) {
      case PublicationPlan.freeOnce:
        return 1.0;
      case PublicationPlan.starter:
        return 1.2;
      case PublicationPlan.plus:
        return 1.5;
      case PublicationPlan.pro:
        return 2.0;
    }
  }

  /// Número de renovaciones manuales permitidas.
  int get maxRenewals {
    switch (this) {
      case PublicationPlan.freeOnce:
        return 0;
      case PublicationPlan.starter:
        return 1;
      case PublicationPlan.plus:
        return 3;
      case PublicationPlan.pro:
        return 5;
    }
  }

  /// Flag lifetime-only.
  bool get isLifetimeOnce => this == PublicationPlan.freeOnce;

  /// Wire names explícitos y versionables (no uses enum.name).
  String get wireName {
    switch (this) {
      case PublicationPlan.freeOnce:
        return 'free_once';
      case PublicationPlan.starter:
        return 'starter';
      case PublicationPlan.plus:
        return 'plus';
      case PublicationPlan.pro:
        return 'pro';
    }
  }

  /// Parse seguro desde string externo.
  static PublicationPlan fromWire(String raw) {
    switch (raw) {
      case 'free_once':
        return PublicationPlan.freeOnce;
      case 'starter':
        return PublicationPlan.starter;
      case 'plus':
        return PublicationPlan.plus;
      case 'pro':
        return PublicationPlan.pro;
      default:
        throw ArgumentError('PublicationPlan desconocido: $raw');
    }
  }
}

/// Contrato fuerte para políticas de plan/créditos.
/// Todos los mutadores deben ejecutarse dentro de una transacción atómica.
abstract class PublicationPlanPolicy {
  /// Saldo actual de créditos del usuario (>= 0).
  int get userCreditsBalance;

  /// Si el usuario ya consumió su publicación gratuita lifetime.
  bool get freeOnceConsumed;

  /// Cantidad de renovaciones realizadas en esta publicación.
  int get renewalsUsed;

  /// Ventana de boost en horas desde el "claim".
  Duration get boostWindow => const Duration(hours: 24);

  /// Descuenta créditos del saldo del usuario.
  void consumeCredits(int amount);

  /// Marca como consumida la publicación gratuita lifetime del usuario.
  void markFreeOnceConsumed();

  /// Incrementa el contador de renovaciones de la publicación.
  void incrementRenewals();

  /// Idempotencia: ¿el requestId ya fue procesado?
  bool isRequestProcessed(String requestId);

  /// Marca un requestId como procesado.
  void markRequestProcessed(String requestId);
}

/// Resultado de operación de plan (patrón Result).
abstract class PlanOperationResult {
  const PlanOperationResult();
}

/// Operación exitosa con datos de resultado.
class PlanOpSuccess extends PlanOperationResult {
  final DateTime expireAtUtc;
  final int creditsConsumed;
  final int boostsIncluded;
  final String planWireName;
  final String auditReason;
  final DateTime processedAtUtc;

  const PlanOpSuccess({
    required this.expireAtUtc,
    required this.creditsConsumed,
    required this.boostsIncluded,
    required this.planWireName,
    required this.auditReason,
    required this.processedAtUtc,
  });

  /// Copia con cambios para enriquecer auditoría.
  PlanOpSuccess copyWith({
    DateTime? expireAtUtc,
    int? creditsConsumed,
    int? boostsIncluded,
    String? planWireName,
    String? auditReason,
    DateTime? processedAtUtc,
  }) {
    return PlanOpSuccess(
      expireAtUtc: expireAtUtc ?? this.expireAtUtc,
      creditsConsumed: creditsConsumed ?? this.creditsConsumed,
      boostsIncluded: boostsIncluded ?? this.boostsIncluded,
      planWireName: planWireName ?? this.planWireName,
      auditReason: auditReason ?? this.auditReason,
      processedAtUtc: processedAtUtc ?? this.processedAtUtc,
    );
  }
}

/// Operación fallida con código y metadata para analytics y UX.
class PlanOpFailure extends PlanOperationResult {
  final String code;
  final String message;
  final Map<String, Object?> metadata;

  const PlanOpFailure(
    this.code,
    this.message, {
    this.metadata = const {},
  });
}

/// Servicio de dominio para validación y efectos de planes.
class PublicationPlanService {
  /// Verifica si el usuario puede activar un plan.
  static bool canActivate({
    required PublicationPlan plan,
    required PublicationPlanPolicy policy,
  }) {
    if (plan.isLifetimeOnce && policy.freeOnceConsumed) return false;
    if (policy.userCreditsBalance < plan.creditsRequired) return false;
    return true;
  }

  /// Activa un plan con idempotencia y transacción atómica.
  static PlanOperationResult activate({
    required PublicationPlan plan,
    required PublicationPlanPolicy policy,
    required DateTime nowUtc,
    required String requestId,
  }) {
    assert(nowUtc.isUtc, 'nowUtc debe ser UTC');

    if (policy.isRequestProcessed(requestId)) {
      return PlanOpFailure(
        'duplicate_operation',
        'Operación ya procesada',
        metadata: {'requestId': requestId},
      );
    }

    if (plan.isLifetimeOnce && policy.freeOnceConsumed) {
      return const PlanOpFailure(
        'plan_not_eligible',
        'El plan freeOnce ya fue usado',
        metadata: {'reason': 'freeOnce_already_consumed'},
      );
    }

    if (plan.creditsRequired > 0) {
      if (policy.userCreditsBalance < plan.creditsRequired) {
        return PlanOpFailure(
          'insufficient_credits',
          'Créditos insuficientes',
          metadata: {
            'needed': plan.creditsRequired,
            'available': policy.userCreditsBalance,
          },
        );
      }
      try {
        policy.consumeCredits(plan.creditsRequired);
      } catch (e) {
        return PlanOpFailure(
          'credits_transaction_failed',
          'Error al consumir créditos: $e',
        );
      }
    } else if (plan.isLifetimeOnce && !policy.freeOnceConsumed) {
      try {
        policy.markFreeOnceConsumed();
      } catch (e) {
        return PlanOpFailure(
          'free_once_transaction_failed',
          'Error al marcar freeOnce como consumido: $e',
        );
      }
    }

    final expireAt = computeExpiration(plan: plan, createdAtUtc: nowUtc);
    policy.markRequestProcessed(requestId);

    return PlanOpSuccess(
      expireAtUtc: expireAt,
      creditsConsumed: plan.creditsRequired,
      boostsIncluded: plan.boostsIncluded,
      planWireName: plan.wireName,
      auditReason: 'plan_activated',
      processedAtUtc: nowUtc,
    );
  }

  /// Fecha de expiración determinística desde createdAt (UTC).
  static DateTime computeExpiration({
    required PublicationPlan plan,
    required DateTime createdAtUtc,
  }) {
    assert(createdAtUtc.isUtc, 'createdAtUtc debe ser UTC');
    return createdAtUtc.add(Duration(days: plan.durationDays));
  }

  /// Expiración para renovación con stacking.
  static DateTime computeRenewalExpiration({
    required PublicationPlan plan,
    required DateTime nowUtc,
    required DateTime currentExpireAtUtc,
  }) {
    assert(nowUtc.isUtc, 'nowUtc debe ser UTC');
    assert(currentExpireAtUtc.isUtc, 'currentExpireAtUtc debe ser UTC');

    final base =
        nowUtc.isAfter(currentExpireAtUtc) ? nowUtc : currentExpireAtUtc;
    return base.add(Duration(days: plan.durationDays));
  }

  /// Puede renovarse manualmente según límite del plan.
  static bool canRenew({
    required PublicationPlan plan,
    required PublicationPlanPolicy policy,
  }) {
    return policy.renewalsUsed < plan.maxRenewals;
  }

  /// Renovación con idempotencia y stacking de tiempo.
  static PlanOperationResult renew({
    required PublicationPlan plan,
    required PublicationPlanPolicy policy,
    required DateTime nowUtc,
    required DateTime currentExpireAtUtc,
    required String requestId,
  }) {
    assert(nowUtc.isUtc, 'nowUtc debe ser UTC');
    assert(currentExpireAtUtc.isUtc, 'currentExpireAtUtc debe ser UTC');

    if (policy.isRequestProcessed(requestId)) {
      return PlanOpFailure(
        'duplicate_operation',
        'Operación ya procesada',
        metadata: {'requestId': requestId},
      );
    }

    if (plan.creditsRequired == 0 && plan.isLifetimeOnce) {
      return const PlanOpFailure(
        'non_renewable',
        'El plan freeOnce no es renovable',
      );
    }

    if (!canRenew(plan: plan, policy: policy)) {
      return PlanOpFailure(
        'renewal_limit',
        'Límite de renovaciones alcanzado',
        metadata: {'limit': plan.maxRenewals, 'used': policy.renewalsUsed},
      );
    }

    if (policy.userCreditsBalance < plan.creditsRequired) {
      return PlanOpFailure(
        'insufficient_credits',
        'Créditos insuficientes para renovar',
        metadata: {
          'needed': plan.creditsRequired,
          'available': policy.userCreditsBalance
        },
      );
    }

    try {
      policy.consumeCredits(plan.creditsRequired);
      policy.incrementRenewals();
    } catch (e) {
      return PlanOpFailure('renewal_transaction_failed',
          'Error en transacción de renovación: $e');
    }

    final newExpireAt = computeRenewalExpiration(
      plan: plan,
      nowUtc: nowUtc,
      currentExpireAtUtc: currentExpireAtUtc,
    );

    policy.markRequestProcessed(requestId);

    return PlanOpSuccess(
      expireAtUtc: newExpireAt,
      creditsConsumed: plan.creditsRequired,
      boostsIncluded: 0, // Renovar no otorga boosts adicionales
      planWireName: plan.wireName,
      auditReason: 'plan_renewed',
      processedAtUtc: nowUtc,
    );
  }
}

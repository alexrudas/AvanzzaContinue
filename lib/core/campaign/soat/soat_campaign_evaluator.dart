// ============================================================================
// lib/core/campaign/soat/soat_campaign_evaluator.dart
// SOAT CAMPAIGN EVALUATOR — Funciones puras de evaluación de vencimiento SOAT
//
// QUÉ HACE:
// - Evalúa el estado de una póliza SOAT a partir de su fecha de vencimiento.
// - Calcula días restantes y clasifica el estado (activo / próximo / vencido).
// - Determina la prioridad de campaña para el Campaign Engine.
//
// QUÉ NO HACE:
// - No accede a repositorios ni al dominio directamente.
// - No depende de Flutter ni GetX.
// - No guarda estado — funciones puras, sin side-effects.
//
// PRINCIPIOS:
// - FUENTE ÚNICA DE VERDAD para la lógica de evaluación SOAT.
// - Reutilizable tanto en el Campaign Engine como en el módulo Seguros del Asset OS.
// - Fechas comparadas en UTC para consistencia entre zonas horarias.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Núcleo del Campaign Engine SOAT v1.
// Reutilizar evaluateSoat() y getSoatPriority() en el módulo Seguros
// del AssetDetail cuando se implemente (Fase 10 del Campaign Engine).
// ============================================================================

/// Estado de vigencia de una póliza SOAT.
enum SoatState {
  /// El SOAT está vigente con más de 30 días restantes.
  active,

  /// El SOAT vence pronto (0 a 30 días restantes).
  upcoming,

  /// El SOAT ya venció (días negativos).
  expired,
}

/// Nivel de prioridad para la campaña SOAT.
///
/// Se usa tanto para priorizar el activo más urgente entre un portafolio
/// como para determinar la frecuencia de visualización en el Campaign Engine.
enum SoatPriority {
  /// Más de 30 días — sin urgencia. No se genera campaña.
  none,

  /// 16 a 30 días — campaña informativa.
  low,

  /// 8 a 15 días — campaña de alerta moderada.
  medium,

  /// 3 a 7 días — campaña de alerta alta.
  high,

  /// Vencido o ≤ 2 días — campaña urgente.
  critical,
}

/// Resultado de la evaluación de un SOAT.
///
/// Retorna tanto el estado semántico como los días numéricos para
/// que el caller pueda construir mensajes contextuales precisos.
class SoatEvaluation {
  /// Estado de vigencia.
  final SoatState state;

  /// Días restantes hasta el vencimiento.
  /// Negativo si el SOAT ya venció.
  final int diasRestantes;

  const SoatEvaluation({
    required this.state,
    required this.diasRestantes,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// FUNCIONES PURAS
// ─────────────────────────────────────────────────────────────────────────────

/// Evalúa el estado de vencimiento de un SOAT a partir de su fecha de fin.
///
/// Usa la diferencia en UTC para garantizar consistencia entre zonas horarias.
/// El cálculo es en días completos (inDays) — ignorando fracciones de día.
///
/// Ejemplo:
/// ```dart
/// final eval = evaluateSoat(policy.fechaFin);
/// print(eval.state);         // SoatState.upcoming
/// print(eval.diasRestantes); // 14
/// ```
SoatEvaluation evaluateSoat(DateTime fechaVencimiento) {
  final diasRestantes = fechaVencimiento
      .toUtc()
      .difference(DateTime.now().toUtc())
      .inDays;

  final SoatState state;
  if (diasRestantes < 0) {
    state = SoatState.expired;
  } else if (diasRestantes <= 30) {
    state = SoatState.upcoming;
  } else {
    state = SoatState.active;
  }

  return SoatEvaluation(state: state, diasRestantes: diasRestantes);
}

/// Clasifica la urgencia de un SOAT en niveles de prioridad para el Campaign Engine.
///
/// Reglas de negocio:
/// - `critical` → vencido (< 0) o ≤ 2 días — acción inmediata requerida
/// - `high`     → 3 a 7 días — alerta alta, renovación urgente
/// - `medium`   → 8 a 15 días — alerta moderada, cotizar pronto
/// - `low`      → 16 a 30 días — aviso preventivo, planificar renovación
/// - `none`     → > 30 días — sin urgencia, no se genera campaña
///
/// FUENTE ÚNICA DE VERDAD: importar esta función tanto en Campaign Engine
/// como en el módulo Seguros del AssetDetail (ver Fase 10 del Campaign Engine).
SoatPriority getSoatPriority(int diasRestantes) {
  if (diasRestantes < 0 || diasRestantes <= 2) return SoatPriority.critical;
  if (diasRestantes <= 7)  return SoatPriority.high;
  if (diasRestantes <= 15) return SoatPriority.medium;
  if (diasRestantes <= 30) return SoatPriority.low;
  return SoatPriority.none;
}
